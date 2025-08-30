import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../user/domain/entities/user_entity.dart';
import '../../../../../user/model/user_model/user_model.dart';
import 'block_privacy_remote_datasource.dart';

class BlockPrivacyRemoteDataSourceImpl implements BlockPrivacyRemoteDataSource {
  final FirebaseFirestore firestore;

  BlockPrivacyRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> blockUser(UserModel user, String uid) async {
    await firestore.collection('users').doc(uid).set({
      'privacy': {
        'blockedList': FieldValue.arrayUnion([user.uid])
      }
    }, SetOptions(merge: true));
  }

  @override
  Future<void> unblockUser(UserModel user, String uid) async {
    await firestore.collection('users').doc(uid).set({
      'privacy': {
        'blockedList': FieldValue.arrayRemove([user.uid])
      }
    }, SetOptions(merge: true));
  }

  @override
  Future<List<UserModel>> getBlockedUsers(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    final data = doc.data();

    final List<String> blockedUids = List<String>.from(data?['privacy']?['blockedList'] ?? []);

    // جلب بيانات كل مستخدم محظور وتحويلها إلى UserModel
    final List<UserModel> blockedUsers = [];
    for (final blockedUid in blockedUids) {
      final userDoc = await firestore.collection('users').doc(blockedUid).get();
      if (userDoc.exists) {
        blockedUsers.add(UserModel.fromMap(userDoc.data()!));

      }
    }
    return blockedUsers;
  }

}
