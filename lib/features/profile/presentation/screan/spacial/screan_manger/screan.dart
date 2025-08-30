import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodel/report/get_report_vm.dart';
import '../widget_manger/widget_report.dart';



class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(myReportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقارير المستخدمين'),
        backgroundColor: Colors.orange,
      ),
      body: reportsAsync.when(
        data: (reports) {
          if (reports.isEmpty) {
            return const Center(
              child: Text('لا توجد تقارير حتى الآن'),
            );
          }
          return ListView.separated(
            itemCount: reports.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final report = reports[index];
              return ReportListItem(report: report);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('حدث خطأ أثناء جلب التقارير: $error'),
        ),
      ),
    );
  }
}
