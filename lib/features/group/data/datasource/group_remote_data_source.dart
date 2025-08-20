import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:uuid/uuid.dart';

import '../../../../storsge/repository.dart';
import '../model/group/group.dart';

class GroupRemoteDataSource {
  final FirebaseFirestore fire;
  final FirebaseAuth auth;
  final FirebaseStorageRepository storageRepository;

  GroupRemoteDataSource({
    required this.fire, required this.auth, required this.storageRepository,
  });

  Future<void> createGroup(String name, File profile, List<Contact> selectedContacts) async {
    String text = '';
    List<String> uids = [];

    for (var contact in selectedContacts) {
      if (contact.phones.isEmpty) continue;

      var userCollection = await fire
          .collection('users')
          .where('phoneNumber', isEqualTo: contact.phones[0].number.replaceAll(' ', ''))
          .get();

      if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
        uids.add(userCollection.docs[0].data()['uid']);
      }
    }

    var groupId = const Uuid().v1();
    String profileUrl = await storageRepository.storeFiletofirstorage(
      'group/$groupId',
      profile,
    );

    Map<String, int> unreadMessageCount = {};
    for (var uid in [auth.currentUser!.uid, ...uids]) {
      unreadMessageCount[uid] = 0;
    }

    // 4. حفظ بيانات الجروب في Firestore
    final group = {
      'senderId': auth.currentUser!.uid,
      'name': name,
      'groupId': groupId,
      'lastMessage': text,
      'groupPic': profileUrl,
      'membersUid': [auth.currentUser!.uid, ...uids],
      'timeSent': DateTime.now().millisecondsSinceEpoch,
      'unreadMessageCount': unreadMessageCount,
      'ownerUid': auth.currentUser!.uid,
      'adminUids': [auth.currentUser!.uid],
    };

    await fire.collection('groups').doc(groupId).set(group);
  }

  Future<GroupModel> getGroupById(String groupId) async {
    final doc = await fire.collection('groups').doc(groupId).get();
    if (!doc.exists) {
      throw Exception('Group not found');
    }
    final data = doc.data()!;
    return GroupModel(
      groupId: data['groupId'],
      ownerUid: data['ownerUid'],
      adminUids: List<String>.from(data['adminUids'] ?? []),
      membersUid: List<String>.from(data['membersUid'] ?? []),
      name: data['name'] ?? '',
      groupPic: data['groupPic'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      timeSent: data['timeSent'] ?? 0,
      unreadMessageCount: Map<String, int>.from(data['unreadMessageCount'] ?? {}),
      archivedUsers:List<String>.from(data['archivedUsers'] ?? []),
    );
  }

  Future<void> deleteGroup(String groupId) async {await fire.collection('groups').doc(groupId).delete();}



  Stream<GroupModel> getGroupData(String groupId) {
    return fire
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((event) => GroupModel.fromMap(event.data()!));
  }

  Future<void> addUsersToGroup(List<Contact> selectedContacts, String groupId) async {
    var groupDoc = await fire.collection('groups').doc(groupId).get();
    List<String> currentMembersUid = List<String>.from(
        groupDoc.data()?['membersUid'] ?? []);

    List<String> uidsToAdd = [];

    for (var contact in selectedContacts) {
      if (contact.phones.isEmpty) continue;

      var userCollection = await fire
          .collection('users')
          .where('phoneNumber',
          isEqualTo: contact.phones[0].number.replaceAll(' ', ''))
          .get();

      if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
        String uid = userCollection.docs[0].data()['uid'];
        if (!currentMembersUid.contains(uid)) {
          uidsToAdd.add(uid);
        }
      }
    }

    if (uidsToAdd.isNotEmpty) {
      currentMembersUid.addAll(uidsToAdd);
      await fire.collection('groups').doc(groupId).update({
        'membersUid': currentMembersUid,
      });
    }
  }

  Future<void> deleteMemberFromGroup(String groupId, String memberId) async {
    var groupDoc = await fire.collection('groups').doc(groupId).get();
    List<String> currentMembersUid = List<String>.from(
        groupDoc.data()?['membersUid'] ?? []);
    String adminUid = groupDoc.data()?['adminUid'] ?? '';

    if (auth.currentUser!.uid != adminUid) {
      throw Exception('Only admins can remove members');
    }

    if (currentMembersUid.contains(memberId)) {
      currentMembersUid.remove(memberId);
      await fire.collection('groups').doc(groupId).update({
        'membersUid': currentMembersUid,
      });
    } else {
      throw Exception('Member not found in the group');
    }
  }

  Future<String> getAdminUid(String groupId) async {
    final doc = await fire.collection('groups').doc(groupId).get();
    if (doc.exists) {
      return doc.data()!['adminUid'] as String;
    } else {
      throw Exception('Group not found');
    }
  }

  Future<String?> getUserIdByPhone(String phoneNumber) async {
    final snapshot = await fire
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first['uid'];
  }

  Future<void> addAdmin(String groupId, String userIdToAdd) async {
    final groupDoc = await fire.collection('groups').doc(groupId).get();
    if (!groupDoc.exists) {
      throw Exception("Group not found");
    }

    final data = groupDoc.data()!;
    final ownerUid = data['ownerUid'];

    if (auth.currentUser!.uid != ownerUid) {
      throw Exception("Only the group owner can add admins");
    }

    await fire.collection('groups').doc(groupId).update({
      'adminUids': FieldValue.arrayUnion([userIdToAdd]),
    });
  }

  Future<void> removeAdmin(String groupId, String userIdToRemove) async {
    final groupDoc = await fire.collection('groups').doc(groupId).get();
    if (!groupDoc.exists) {
      throw Exception("Group not found");
    }

    final data = groupDoc.data()!;
    final ownerUid = data['ownerUid'];

    if (auth.currentUser!.uid != ownerUid) {
      throw Exception("Only the group owner can remove admins");
    }

    await fire.collection('groups').doc(groupId).update({
      'adminUids': FieldValue.arrayRemove([userIdToRemove]),
    });
  }

  Future<void> leaveGroup(String groupId) async {
    final userId = auth.currentUser!.uid;

    final doc = await fire.collection('groups').doc(groupId).get();

    if (!doc.exists) throw Exception("Group not found");

    final members = List<String>.from(doc.data()!['membersUid']);

    if (!members.contains(userId)) return;

    members.remove(userId);

    await fire.collection('groups').doc(groupId).update({
      'membersUid': members,
    });
  }

  Future<void> updateGroupNameAndImage({required String groupId, String? newName, File? newProfileImage, // إذا null معناها لم يتغير الصورة
  }) async {
    // تحقق من صلاحية المستخدم (مالك أو أدمن)
    final groupDoc = await fire.collection('groups').doc(groupId).get();
    if (!groupDoc.exists) {
      throw Exception("Group not found");
    }
    final data = groupDoc.data()!;
    final ownerUid = data['ownerUid'] as String;
    final adminUids = List<String>.from(data['adminUids'] ?? []);

    final currentUserUid = auth.currentUser!.uid;
    if (currentUserUid != ownerUid && !adminUids.contains(currentUserUid)) {
      throw Exception("Only owner or admins can update group info");
    }

    Map<String, dynamic> updateData = {};

    // تحديث الاسم إذا تم تمريره
    if (newName != null && newName.trim().isNotEmpty) {
      updateData['name'] = newName.trim();
    }

    // تحديث الصورة إذا تم تمرير ملف جديد
    if (newProfileImage != null) {
      final profileUrl = await storageRepository.storeFiletofirstorage(
        'group/$groupId',
        newProfileImage,
      );
      updateData['groupPic'] = profileUrl;
    }

    if (updateData.isNotEmpty) {
      await fire.collection('groups').doc(groupId).update(updateData);
    }
  }

}
