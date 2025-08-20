import 'package:flutter/material.dart';

import '../../../../domain/entities/report/report_entities.dart';

class ReportListItem extends StatelessWidget {
  final ReportEntity report;

  const ReportListItem({
    Key? key,
    required this.report,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.report, color: Colors.orange),
      title: Text('مبلغ عليه: ${report.reportedUserId}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('السبب: ${report.reason}'),
          Text('تاريخ البلاغ: ${report.timestamp?.toLocal()}'),
        ],
      ),
      isThreeLine: true,
    );
  }
}
