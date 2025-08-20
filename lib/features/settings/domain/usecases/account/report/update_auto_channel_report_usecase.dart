import '../../../repository/account/report/report_settings_repository.dart';

class UpdateAutoChannelReportUseCase {
  final ReportSettingsRepository repository;

  UpdateAutoChannelReportUseCase(this.repository);

  Future<void> call(bool enabled) {
    return repository.updateAutoChannelReport(enabled);
  }
}
