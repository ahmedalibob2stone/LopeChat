
import '../../../repository/account/report/report_settings_repository.dart';

class UpdateAutoAccountReportUseCase {
  final ReportSettingsRepository repository;

  UpdateAutoAccountReportUseCase(this.repository);

  Future<void> call(bool enabled) {
    return repository.updateAutoAccountReport(enabled);
  }
}
