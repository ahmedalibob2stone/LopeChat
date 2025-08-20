

import '../../entities/report/report_entities.dart';
import '../../repository/report/report_repository.dart';

class GetMyReportsUseCase {
  final ReportRepository repository;

  GetMyReportsUseCase(this.repository);

  Future<List<ReportEntity>> call() async {
    return await repository.getMyReports();
  }
}
