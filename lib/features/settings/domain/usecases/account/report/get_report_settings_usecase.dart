

import '../../../entities/account/report/report_settings_entity.dart';
import '../../../repository/account/report/report_settings_repository.dart';

class GetReportSettingsUseCase {
  final ReportSettingsRepository repository;

  GetReportSettingsUseCase(this.repository);

  Future<ReportSettingsEntity> call() {
    return repository.getReportSettings();
  }
}
