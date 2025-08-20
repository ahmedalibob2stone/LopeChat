import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/privacy/bout/privacy_about_model.dart';

class PrivacyAboutRemoteDatasourceImpl {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  PrivacyAboutRemoteDatasourceImpl({
    required this.firestore,
    required this.auth,
  });

  Future<void> updatePrivacyAbout(PrivacyAboutModel model) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    await firestore
        .collection('users')
        .doc(userId)
        .collection('privacy_about')
        .doc('settings')
        .set(model.toMap());
  }

  Future<PrivacyAboutModel> getPrivacyAbout() async {
    final userId = auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final doc = await firestore
        .collection('users')
        .doc(userId)
        .collection('privacy_about')
        .doc('settings')
        .get();

    if (doc.exists) {
      return PrivacyAboutModel.fromMap(doc.data()!);
    } else {
      return PrivacyAboutModel(

        visibility: 'everyone',
        exceptUids: [],
      );
    }
  }
}
