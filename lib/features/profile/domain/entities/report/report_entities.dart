class ReportEntity {
  final String id;
  final String reportedUserId;
  final String reporterUserId;
  final String reason;
  final DateTime? timestamp;

  ReportEntity({
    required this.id,
    required this.reportedUserId,
    required this.reporterUserId,
    required this.reason,
    this.timestamp,
  });
}
