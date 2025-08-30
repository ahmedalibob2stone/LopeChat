import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/report/report_entities.dart';

class ReportModel extends ReportEntity {
  ReportModel({
    required String id,
    required String reportedUserId,
    required String reporterUserId,
    required String reason,
    DateTime? timestamp,
  }) : super(
    id: id,
    reportedUserId: reportedUserId,
    reporterUserId: reporterUserId,
    reason: reason,
    timestamp: timestamp,
  );

  factory ReportModel.fromMap(Map<String, dynamic> map, String id) {
    return ReportModel(
      id: id,
      reportedUserId: map['reportedUserId'] ?? '',
      reporterUserId: map['reporterUserId'] ?? '',
      reason: map['reason'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reportedUserId': reportedUserId,
      'reporterUserId': reporterUserId,
      'reason': reason,
      'timestamp': timestamp,
    };
  }

  ReportEntity toEntity() => ReportEntity(
    id: id,
    reportedUserId: reportedUserId,
    reporterUserId: reporterUserId,
    reason: reason,
    timestamp: timestamp,
  );
}
