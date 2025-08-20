
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/privacy/group/group_privacy_model.dart';
abstract class GroupPrivacyRemoteDataSource{
  Future<GroupPrivacyModel> getGroupPrivacy(String uid);

  Future<void> updateGroupPrivacy(GroupPrivacyModel model,String uid);
}
class GroupPrivacyRemoteDataSourceImpl implements GroupPrivacyRemoteDataSource{
  final FirebaseFirestore firestore;

  GroupPrivacyRemoteDataSourceImpl({
    required this.firestore,
  });

  Future<GroupPrivacyModel> getGroupPrivacy(String uid) async {

    final snapshot = await firestore.collection('users').doc(uid).get();

    final data = snapshot.data()?['privacy']?['groupPrivacy'] ?? {};

    return GroupPrivacyModel.fromMap({
      'visibility': data['visibility'] ?? 'everyone',
      'exceptUids': data['exceptUids'] ?? [],
    });
  }

  Future<void> updateGroupPrivacy(GroupPrivacyModel model,String uid) async {

    await firestore.collection('users').doc(uid).set({
      'privacy': {
        'groupPrivacy': model.toMap(),
      },
    }, SetOptions(merge: true));
  }
}
