class ReportSettingsEntity {
  final bool autoAccountReportEnabled;
  final bool autoChannelReportEnabled;

  ReportSettingsEntity({
    required this.autoAccountReportEnabled,
    required this.autoChannelReportEnabled,
  });

  ReportSettingsEntity copyWith({
    bool? autoAccountReportEnabled,
    bool? autoChannelReportEnabled,
  }) {
    return ReportSettingsEntity(
      autoAccountReportEnabled: autoAccountReportEnabled ?? this.autoAccountReportEnabled,
      autoChannelReportEnabled: autoChannelReportEnabled ?? this.autoChannelReportEnabled,
    );
  }
}
