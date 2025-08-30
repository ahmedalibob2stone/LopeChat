

import '../../entities/report/report_entities.dart';

abstract class ReportRepository {
  Future<void> reportUser({
    required String reportedUserId,
    required String reason,

  });

  Future<List<ReportEntity>> getMyReports();
}
