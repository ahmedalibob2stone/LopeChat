import 'package:lopechat/features/settings/data/datasource/privacy/calls/privacy_calls_remote_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/privacy/calls/privacy_calls_model.dart';

class PrivacyCallsRemoteDatasourceImpl implements PrivacyCallsRemoteDatasource {
  final FirebaseFirestore firestore;


  PrivacyCallsRemoteDatasourceImpl({
    required this.firestore,
  });
  @override

  Future<PrivacyCallsModel> getPrivacyCalls(String uid) async {
    final snapshot = await firestore.collection('users').doc(uid).get();

    return PrivacyCallsModel.fromMap(snapshot.data()?['privacy']?['privacyCalls'] ?? {});
  }

  @override
  Future<void> updatePrivacyCalls(bool silence, String uid) async {
    await firestore.collection('users').doc(uid).set({
      'privacy': {
        'callsPrivacy': {
          'silenceUnknownCallers': silence,
        }
      }
    }, SetOptions(merge: true));
  }
}
