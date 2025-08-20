import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../user/model/user_model/user_model.dart';
import '../../model/block/block_privacy_model.dart';
import 'block_user_remote_datasorce.dart';

class BlockDataSourceImpl implements BlockDataSource {
  final FirebaseFirestore firestore;

  BlockDataSourceImpl(this.firestore);



  @override
  Future<void> blockUser({required String currentUserId,required String blockedUserId,
    required String blockedId})
  async {
    final docRef = firestore
        .collection('users')
        .doc(currentUserId)
        .collection('blocked_users')
        .doc(blockedId); // معرف تلقائي
    final blockModel = BlockModel(
      blockId: blockedId,
      blockedUserId: blockedUserId,
      blockedAt: DateTime.now(),
    );
    await docRef.set(blockModel.toMap());
  }


  @override
  Future<void> unblockUser({
    required String currentUserId,
    required String block,
  }) async {

    await firestore
        .collection('users')
        .doc(currentUserId)
        .collection('blocked_users')
        .doc(block)
        .delete();
  }

  Future<bool> isBlocked({required String currentUserId, required String otherUserId}) async {
    final currentUserBlockedQuery = await firestore
        .collection('users')
        .doc(currentUserId)
        .collection('blocked_users')
        .where('blockedUserId', isEqualTo: otherUserId)
        .limit(1)
        .get();

    final otherUserBlockedQuery = await firestore
        .collection('users')
        .doc(otherUserId)
        .collection('blocked_users')
        .where('blockedUserId', isEqualTo: currentUserId)
        .limit(1)
        .get();

    return currentUserBlockedQuery.docs.isNotEmpty || otherUserBlockedQuery.docs.isNotEmpty;
  }

  @override
  Future<void> clearMessages({
    required String currentUserId,
    required String chatId,
  }) async {
    final messagesRef = firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    final snapshots = await messagesRef.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
  Future<List<UserModel>> getBlockedUsers({required String currentUserId}) async {
    try {
      final blockedUsers = <UserModel>[];

      final blockedUsersSnapshot = await firestore
          .collection('users')
          .doc(currentUserId)
          .collection('blocked_users')
          .get();

      for (var doc in blockedUsersSnapshot.docs) {
        final blockModel = BlockModel.fromMap(doc.data(), doc.id);

        final userDoc = await firestore.collection('users').doc(blockModel.blockedUserId).get();
        if (userDoc.exists && userDoc.data() != null) {
          blockedUsers.add(UserModel.fromMap(userDoc.data()!));
        }
      }

      return blockedUsers;
    } catch (e, stackTrace) {
      print('Error fetching blocked users: $e');
      print(stackTrace);
      // إعادة قائمة فارغة أو رفع استثناء حسب الحاجة
      return [];
    }
  }

}
