

import '../../../entities/account/report/report_settings_entity.dart';
import '../../../repository/account/report/report_settings_repository.dart';

class SetReportSettingsUseCase {
  final ReportSettingsRepository repository;

  SetReportSettingsUseCase(this.repository);

  Future<void> call(ReportSettingsEntity settings) {
    return repository.setReportSettings(settings);
  }
}
