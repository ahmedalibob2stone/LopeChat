
import '../../repository/report/report_repository.dart';

class ReportUserUseCase {
  final ReportRepository repository;

  ReportUserUseCase(this.repository);

  Future<void> call({
    required String reportedUserId,
    required String reason,

  }) async {
    await repository.reportUser(
      reportedUserId: reportedUserId,
      reason: reason,

    );
  }
}
