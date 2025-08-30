


import '../../../domain/entities/report/report_entities.dart';
import '../../../domain/repository/report/report_repository.dart';
import '../../datasource/report/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> reportUser({required String reportedUserId, required String reason,
}) async {
    return await remoteDataSource.reportUser(
      reportedUserId: reportedUserId,
      reason: reason

    );
  }

  @override
  Future<List<ReportEntity>> getMyReports() async {
    final reportModels = await remoteDataSource.getMyReports();
    return reportModels.map((model) => model.toEntity()).toList();
  }
}
