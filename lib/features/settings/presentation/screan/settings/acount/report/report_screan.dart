import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../profile/presentation/provider/report/vm/provider.dart';
import '../../../../../../profile/presentation/viewmodel/report/get_report_vm.dart';
import '../../../../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../../../../provider/account/report/viewmodel/provider.dart';


class AccountReportScreen extends ConsumerWidget {
  const AccountReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(reportSettingsViewModelProvider);
    final settingsVM = ref.read(reportSettingsViewModelProvider.notifier);

    final reportVM = ref.read(reportViewModelProvider.notifier);
    final reportsAsync = ref.watch(myReportsProvider);

    final autoAccount = settingsState.settings?.autoAccountReportEnabled ?? false;
    final autoChannel = settingsState.settings?.autoChannelReportEnabled ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Account Info"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: settingsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (settingsState.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                settingsState.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          // --- إعدادات الحساب ---
          Row(
            children: const [
              Icon(Icons.insert_drive_file, color: Colors.teal),
              SizedBox(width: 8),
              Text("Account Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Create a report that includes your account info, settings, and profile photo.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Auto-create reports", style: TextStyle(fontSize: 14)),
              Switch(
                value: autoAccount,
                onChanged: (value) async {
                  await settingsVM.updateAutoAccountReport(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "A new report will be automatically created every few weeks.",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const Divider(height: 32, thickness: 1, color: Colors.grey),

          // --- إعدادات القنوات ---
          Row(
            children: const [
              Icon(Icons.request_page, color: Colors.teal),
              SizedBox(width: 8),
              Text("Channel Reports", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Create a report that includes info about the channels you follow and the content within them.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Auto-create reports", style: TextStyle(fontSize: 14)),
              Switch(
                value: autoChannel,
                onChanged: (value) async {
                  await settingsVM.updateAutoChannelReport(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "A new report will be automatically created every few weeks.",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),

          const SizedBox(height: 40),

          const Text("My Reports", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          reportsAsync.when(
            data: (reports) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];

                final reporterDataAsync = ref.watch(userByIdStreamProvider(report.reporterUserId));
                final reportedDataAsync = ref.watch(userByIdStreamProvider(report.reportedUserId));

                return reporterDataAsync.when(
                  data: (reporterUser) {
                    return reportedDataAsync.when(
                      data: (reportedUser) {
                        return ListTile(
                          title: Text("Report Reason: ${report.reason}"),
                          subtitle: Text("From: ${reporterUser.name} → To: ${reportedUser.name}"),
                          trailing: Text(report.timestamp.toString().split('.').first),
                        );
                      },
                      loading: () => const ListTile(title: Text("Loading reported user...")),
                      error: (e, _) => ListTile(title: Text("Error loading reported user")),
                    );
                  },
                  loading: () => const ListTile(title: Text("Loading reporter...")),
                  error: (e, _) => ListTile(title: Text("Error loading reporter")),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(error.toString(), style: const TextStyle(color: Colors.red)),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () async {
              await reportVM.reportUser(
                reportedUserId: "USER_UID_HERE", // ← استبدلها بـ UID مستهدف
                reason: "Test Reason", // ← استبدلها بالسبب المطلوب
              );
              ref.invalidate(myReportsProvider); // إعادة تحميل التقارير
            },
            child: const Text("Create New Report"),
          ),
        ],
      ),
    );
  }
}
