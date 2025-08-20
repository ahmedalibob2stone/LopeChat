
import '../../../../domain/entities/account/report/report_settings_entity.dart';
import '../../../../domain/repository/account/report/report_settings_repository.dart';
import '../../../datasource/account/report/report_settings_remote_datasorce.dart';
import '../../../model/account/report/report_settings_model.dart';

class ReportSettingsRepositoryImpl implements ReportSettingsRepository {
  final ReportSettingsRemoteDataSource _remoteDataSource;

  ReportSettingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> setReportSettings(ReportSettingsEntity settings) {
    // تحويل الـ Entity إلى Model إذا لم يكن Model أصلاً
    final model = settings is ReportSettingsModel
        ? settings
        : ReportSettingsModel(
      autoAccountReportEnabled: settings.autoAccountReportEnabled,
      autoChannelReportEnabled: settings.autoChannelReportEnabled,
    );
    return _remoteDataSource.setReportSettings(model);
  }

  @override
  Future<ReportSettingsModel> getReportSettings() {
    return _remoteDataSource.getReportSettings();
  }

  @override
  Future<void> updateAutoAccountReport(bool enabled) {
    return _remoteDataSource.updateAutoAccountReport(enabled);
  }

  @override
  Future<void> updateAutoChannelReport(bool enabled) {
    return _remoteDataSource.updateAutoChannelReport(enabled);
  }
}
