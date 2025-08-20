import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/privacy/auto disappear message/auto_disappear _model.dart';

class AutoDisappearMassagesPrivacyRemoteDatasource {
  final FirebaseFirestore firestore;

  AutoDisappearMassagesPrivacyRemoteDatasource({
    required this.firestore,
  });

  // جلب الإعداد من المستخدم
  Future<DefaultDisappearModel?> getDefaultTimer(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    final data = doc.data();

    if (doc.exists &&
        data != null &&
        data['privacy'] != null &&
        data['privacy']['defaultDisappearTimer'] != null) {
      final timerData = data['privacy']['defaultDisappearTimer']
      as Map<String, dynamic>;
      return DefaultDisappearModel.fromMap(timerData);
    }
    return null;
  }

  // تحديث الإعداد
  Future<void> setDefaultTimer(String uid, String timer) async {
    await firestore.collection('users').doc(uid).set({
      'privacy': {
        'defaultDisappearTimer': {
          'defaultDisappearTimer': timer,
        }
      }
    }, SetOptions(merge: true));
  }
}
