import 'package:lopechat/features/settings/data/datasource/privacy/statu/status_privacy_remote_datasorce.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/privacy/statu/status_privacy_model.dart';

class StatusPrivacyRemoteDataSourceImpl implements StatusPrivacyRemoteDataSource {
  final FirebaseFirestore firestore;

  StatusPrivacyRemoteDataSourceImpl({required this.firestore});

  @override
  Future<StatusPrivacyModel?> getStatusPrivacy({required String userId}) async {
    final doc = await firestore.collection('users').doc(userId).get();
    final data = doc.data();

    if (data != null && data['privacy'] != null && data['privacy']['statu'] != null) {
      return StatusPrivacyModel.fromMap(Map<String, dynamic>.from(data['privacy']['statu']));
    }
    return null;
  }

  @override
  Future<void> saveStatusPrivacy({ required StatusPrivacyModel statusPrivacy,required String userId}) async {
    await firestore.collection('users').doc(userId).set({
      'privacy': {
        'statu': statusPrivacy.toMap(),
      }
    }, SetOptions(merge: true));
  }
}
