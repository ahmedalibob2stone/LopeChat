import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/privacy/statu/vm/status_privascy_viewmodel.dart';
import '../../../../viewmodel/privacy/statu/status_privacy_viewmodel.dart';
import 'my_contact_exception_screan.dart';
import 'onlyshare_with_screan.dart';

class StatusPrivacyScreen extends ConsumerWidget {
  const StatusPrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statusPrivacyProvider);
    final vm = ref.read(statusPrivacyProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('خصوصية الحالة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'من يمكنه رؤية حالاتي الجديدة؟',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // الخيارات الثلاثة
            _buildOption(
              context,
              selected: state.selectedOption == StatusPrivacyOptionUI.allContacts,
              title: 'جهات اتصالي',
              subtitle: null,
              trailing: null,
              onTap: () {
                vm.selectOption(StatusPrivacyOptionUI.allContacts);
                vm.applyChanges();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث الإعدادات')),
                );
              },
            ),

            _buildOption(
              context,
              selected: state.selectedOption == StatusPrivacyOptionUI.contactsExcept,
              title: 'جهات اتصالي باستثناء',
              subtitle: 'تم استثناء ${state.excludedCount} شخص',
              trailing: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ContactsExceptScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('تم استثناء ${state.excludedCount}', style: const TextStyle(color: Colors.red)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
                  ],
                ),
              ),
              onTap: () {
                vm.selectOption(StatusPrivacyOptionUI.contactsExcept);
                vm.applyChanges();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث الإعدادات')),
                );
              },
            ),

            _buildOption(
              context,
              selected: state.selectedOption == StatusPrivacyOptionUI.shareWithOnly,
              title: 'المشاركة مع فقط',
              subtitle: 'تم تضمين ${state.includedCount} شخص',
              trailing: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShareWithOnlyScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('تم تضمين ${state.includedCount}', style: const TextStyle(color: Colors.green)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
                  ],
                ),
              ),
              onTap: () {
                vm.selectOption(StatusPrivacyOptionUI.shareWithOnly);
                vm.applyChanges();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث الإعدادات')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, {
        required bool selected,
        required String title,
        String? subtitle,
        Widget? trailing,
        required VoidCallback onTap,
      }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        selected ? Icons.check_circle : Icons.circle_outlined,
        color: selected ? Colors.green : Colors.grey,
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey)) : null,
      trailing: trailing,
    );
  }
}
