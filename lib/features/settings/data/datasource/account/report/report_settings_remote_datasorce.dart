import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/account/report/report_settings_model.dart';

class ReportSettingsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ReportSettingsRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// تحديث إعدادات التقارير (تلقائيًا أو يدويًا) داخل وثيقة المستخدم
  Future<void> setReportSettings(ReportSettingsModel settings) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    // تحديث حقل reportSettings داخل وثيقة المستخدم
    final userDocRef = _firestore.collection('users').doc(userId);
    await userDocRef.set({
      'reportSettings': settings.toMap(),
    }, SetOptions(merge: true));
  }

  /// جلب إعدادات التقارير للمستخدم الحالي من وثيقة المستخدم
  Future<ReportSettingsModel> getReportSettings() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final docSnapshot = await _firestore.collection('users').doc(userId).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data()!;
      if (data.containsKey('reportSettings')) {
        return ReportSettingsModel.fromMap(data['reportSettings']);
      }
    }

    // إرجاع إعدادات افتراضية إذا لم توجد
    return ReportSettingsModel(
      autoAccountReportEnabled: false,
      autoChannelReportEnabled: false,
    );
  }

  /// تحديث خيار تقرير الحساب التلقائي فقط داخل نفس حقل reportSettings
  Future<void> updateAutoAccountReport(bool enabled) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final userDocRef = _firestore.collection('users').doc(userId);

    await userDocRef.set({
      'reportSettings.autoAccountReportEnabled': enabled,
    }, SetOptions(merge: true));
  }

  /// تحديث خيار تقرير القناة التلقائي فقط داخل نفس حقل reportSettings
  Future<void> updateAutoChannelReport(bool enabled) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final userDocRef = _firestore.collection('users').doc(userId);

    await userDocRef.set({
      'reportSettings.autoChannelReportEnabled': enabled,
    }, SetOptions(merge: true));
  }
}
