import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/privacy/app lock/vm/app_lock_viewmodel.dart';
import 'app_lock.dart';

class AppLockMainScreen extends ConsumerWidget {
  const AppLockMainScreen({Key? key}) : super(key: key);

  void _showBiometricDialog(BuildContext context, WidgetRef ref) async {
    final vm = ref.read(appLockViewModelProvider.notifier);

    bool authenticated = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد المعرف الحيوي'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.fingerprint, size: 64, color: Colors.grey),
              const SizedBox(height: 10),
              const Text('اضغط زر استشعار بصمة الاصبع'),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppLockPasswordScreen(isSettingUp: true,),
                    ),
                  );
                },
                child: const Text('استخدام كلمة المرور بدلاً من ذلك'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                authenticated = await vm.authenticateWithBiometrics();
                if (authenticated) {
                  Navigator.pop(context);
                  // تحميل بيانات القفل للتحديث
                  await vm.loadAppLockData();
                }
              },
              child: const Text('تحقق'),
            )
          ],
        );
      },
    );

    // بعد النجاح اظهر خيارات القفل التلقائي
    if (authenticated) {
      _showAutoLockOptions(context, ref);
    }
  }

  void _showAutoLockOptions(BuildContext context, WidgetRef ref) {
    final vm = ref.read(appLockViewModelProvider.notifier);
    final state = ref.read(appLockViewModelProvider);

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                state.autoLockOption == 0
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: state.autoLockOption == 0 ? Colors.green : null,
              ),
              title: const Text('قفل تلقائي - حالاً'),
              onTap: () {
                vm.setAutoLock(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                state.autoLockOption == 1
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: state.autoLockOption == 1 ? Colors.green : null,
              ),
              title: const Text('قفل تلقائي - بعد دقيقة واحدة'),
              onTap: () {
                vm.setAutoLock(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                state.autoLockOption == 2
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: state.autoLockOption == 2 ? Colors.green : null,
              ),
              title: const Text('قفل تلقائي - بعد 30 دقيقة'),
              onTap: () {
                vm.setAutoLock(2);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appLockViewModelProvider);
    final vm = ref.read(appLockViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('قفل التطبيقات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('فتح القفل بالمعرف الحيوي'),
            subtitle: const Text(
              'عند تمكين هذه الخاصية ستحتاج إلى استخدام بصمة الاصبع أو الوجه لفتح التطبيق. يمكنك الرد على المكالمات حتى إذا كان التطبيق مقفلاً.',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Switch(
              value: state.isAppLockEnabled,
              onChanged: (value) async {
                if (value) {
                  // إظهار الـ biometric dialog
                  _showBiometricDialog(context, ref);
                } else {
                  await vm.updateAppLock(false);
                }
              },
            ),
          ),
          if (state.isAppLockEnabled) ...[
            const Divider(color: Colors.grey),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('قفل تلقائي',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: Icon(
                      state.autoLockOption == 0
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: state.autoLockOption == 0 ? Colors.green : null,
                    ),
                    title: const Text('حالاً'),
                    onTap: () => vm.setAutoLock(0),
                  ),
                  ListTile(
                    leading: Icon(
                      state.autoLockOption == 1
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: state.autoLockOption == 1 ? Colors.green : null,
                    ),
                    title: const Text('بعد دقيقة واحدة'),
                    onTap: () => vm.setAutoLock(1),
                  ),
                  ListTile(
                    leading: Icon(
                      state.autoLockOption == 2
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: state.autoLockOption == 2 ? Colors.green : null,
                    ),
                    title: const Text('بعد 30 دقيقة'),
                    onTap: () => vm.setAutoLock(2),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
