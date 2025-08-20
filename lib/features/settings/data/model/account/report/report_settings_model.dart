import '../../../../domain/entities/account/report/report_settings_entity.dart';

class ReportSettingsModel extends ReportSettingsEntity {
  ReportSettingsModel({
    required bool autoAccountReportEnabled,
    required bool autoChannelReportEnabled,
  }) : super(
    autoAccountReportEnabled: autoAccountReportEnabled,
    autoChannelReportEnabled: autoChannelReportEnabled,
  );

  factory ReportSettingsModel.fromMap(Map<String, dynamic> map) {
    return ReportSettingsModel(
      autoAccountReportEnabled: map['autoAccountReportEnabled'] ?? false,
      autoChannelReportEnabled: map['autoChannelReportEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'autoAccountReportEnabled': autoAccountReportEnabled,
      'autoChannelReportEnabled': autoChannelReportEnabled,
    };
  }
}
