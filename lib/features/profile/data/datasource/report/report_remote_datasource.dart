import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/report/report_usermodel.dart';


class ReportRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ReportRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<void> reportUser({
    required String reportedUserId,
    required String reason,

  }) async {
    final reporterUserId = _auth.currentUser?.uid;
    if (reporterUserId == null) {
      throw Exception('User not logged in');
    }


    final reportsCollection = _firestore.collection('reports');

    final reportData = ReportModel(
      id: '', // Firestore يولد الـ ID تلقائيًا
      reportedUserId: reportedUserId,
      reporterUserId: reporterUserId,
      reason: reason,
      timestamp: DateTime.now(),
    );

    await reportsCollection.add(reportData.toMap());
  }

  Future<List<ReportModel>> getMyReports() async {
    final reporterUserId = _auth.currentUser?.uid;
    if (reporterUserId == null) {
      throw Exception('User not logged in');
    }

    final querySnapshot = await _firestore
        .collection('reports')
        .where('reporterUserId', isEqualTo: reporterUserId)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      return ReportModel.fromMap(doc.data(), doc.id);
    }).toList();
  }
}
