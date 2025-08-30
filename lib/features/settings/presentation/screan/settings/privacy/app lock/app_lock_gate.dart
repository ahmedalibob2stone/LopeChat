import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../responsive/mobile_screen_Layout.dart';
import '../../../../provider/privacy/app lock/vm/app_lock_viewmodel.dart';
import 'app_lock.dart';


class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({Key? key}) : super(key: key);

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> {
  @override
  void initState() {
    super.initState();
    _checkLock();
  }

  Future<void> _checkLock() async {
    final vm = ref.read(appLockViewModelProvider.notifier);
    await vm.loadAppLockData();
    final state = ref.read(appLockViewModelProvider);

    if (state.isAppLockEnabled) {
      final success = await vm.tryBiometricAuth();

      if (!success) {
        if (state.authFailed) {
          _showAuthError();
        }

        // عرض شاشة إدخال كلمة المرور
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AppLockPasswordScreen(isSettingUp:false,)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MobileScreenLayout()),
        );
      }
    } else {
      // لا يوجد قفل - الانتقال مباشرةً
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MobileScreenLayout()),
      );
    }
  }

  void _showAuthError() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('فشل التحقق بالبصمة'),
          content: const Text('لم نتمكن من التحقق من بصمتك.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: const [
            SizedBox(height: 30),
            Icon(Icons.lock, size: 80, color: Colors.grey),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
