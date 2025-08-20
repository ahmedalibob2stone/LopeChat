import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../group/data/model/group/group.dart';


class ChatGroupRemoteDataSource {
  final FirebaseFirestore fire;
  final FirebaseAuth auth;

  ChatGroupRemoteDataSource({
    required this.fire,
    required this.auth,
  });

  Stream<List<GroupModel>> getChatGroups() {
    return fire.collection('groups').snapshots().map((event) {
      List<GroupModel> groups = [];
      for (var document in event.docs) {
        var group = GroupModel.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Stream<List<GroupModel>> searchGroup({required String searchName}) {
    final usercol = fire.collection('groups')
        .where('name', isEqualTo: searchName);

    return usercol.snapshots().map(
            (event) => event.docs.map((e) => GroupModel.fromMap(e.data())).toList()
    );
  }



  Future<void> openGroupChat(String groupId) async {
    var groupDoc = fire.collection('groups').doc(groupId);
    var groupSnapshot = await groupDoc.get();
    var groupData = GroupModel.fromMap(groupSnapshot.data()!);

    Map<String, int> updatedUnreadCounts = Map.from(groupData.unreadMessageCount);
    updatedUnreadCounts[auth.currentUser!.uid] = 0;

    await groupDoc.update({
      'unreadMessageCount': updatedUnreadCounts,
    });
  }



  Future<void> markGroupMessagesAsSeen({
    required String groupId,
    required String uid,
  }) async {
    final groupMessagesCollection =
    fire.collection('groups').doc(groupId).collection('messages');

    final querySnapshot = await groupMessagesCollection
        .where('isSeen', isEqualTo: false)
        .get();

    final batch = fire.batch();

    for (var doc in querySnapshot.docs) {
      final List seenBy = doc.data()['seenBy'] ?? [];

      if (!seenBy.contains(uid)) {
        batch.update(doc.reference, {
          'seenBy': [...seenBy, uid],
        });
      }
    }

    final groupDoc = fire.collection('groups').doc(groupId);
    batch.update(groupDoc, {
      'unreadMessageCount.$uid': 0,
    });

    await batch.commit();
  }
  Future<void> archiveGroupChat({required String groupId, required String userId,}) async {
    await fire.collection('groups').doc(groupId).update({
      'archivedUsers': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unarchiveGroupChat({required String groupId, required String userId,}) async {
    await fire.collection('groups').doc(groupId).update({
      'archivedUsers': FieldValue.arrayRemove([userId]),
    });
  }

  Stream<List<GroupModel>> getArchivedGroups(String userId) {
    return fire.collection('groups')
        .where('membersUid', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => GroupModel.fromMap(doc.data()))
          .where((group) => group.archivedUsers.contains(userId))
          .toList();
    });
  }

  Stream<List<GroupModel>> getUnarchivedGroups(String userId) {
    return fire.collection('groups')
        .where('membersUid', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => GroupModel.fromMap(doc.data()))
          .where((group) => !group.archivedUsers.contains(userId))
          .toList();
    });
  }
  Future<void> deleteGroupChatMessages({required String groupId,}) async {
    try {
      final messagesRef = fire
          .collection('groups')
          .doc(groupId)
          .collection('messages');

      final messagesSnapshot = await messagesRef.get();

      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete group messages: $e');
    }
  }

}
