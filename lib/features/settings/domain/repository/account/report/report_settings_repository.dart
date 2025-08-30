import '../../../entities/account/report/report_settings_entity.dart';

abstract class ReportSettingsRepository {
  Future<void> setReportSettings(ReportSettingsEntity settings);
  Future<ReportSettingsEntity> getReportSettings();
  Future<void> updateAutoAccountReport(bool enabled);
  Future<void> updateAutoChannelReport(bool enabled);
}
