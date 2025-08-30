import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../responsive/mobile_screen_Layout.dart';
import '../../../../provider/privacy/app lock/vm/app_lock_viewmodel.dart';


class AppLockPasswordScreen extends ConsumerStatefulWidget {
  final bool isSettingUp;

  const AppLockPasswordScreen({Key? key,required this.isSettingUp}) : super(key: key);

  @override
  ConsumerState<AppLockPasswordScreen> createState() =>
      _AppLockPasswordScreenState();
}

class _AppLockPasswordScreenState extends ConsumerState<AppLockPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _obscureText = true;
  String? _errorText;

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  Future<void> _submitPassword() async {
    if (widget.isSettingUp) {
      // أول مرة: احفظ كلمة المرور
      final password = _controller.text;
      if (password.isEmpty) {
        setState(() {
          _errorText = 'Please Enter Password';
        });
        return;
      }

      final vm = ref.read(appLockViewModelProvider.notifier);
      await vm.saveLockPassword(password);
      await vm.updateAppLock(true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MobileScreenLayout()),
      );
    } else {
      final vm = ref.read(appLockViewModelProvider.notifier);
      final storedPassword = ref.read(appLockViewModelProvider).password;

      if (_controller.text.isEmpty) {
        setState(() {
          _errorText = 'Please Enter Password';
        });
        return;
      }

      if (_controller.text != storedPassword) {
        setState(() {
          _errorText = 'Incorrect Password';
        });
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MobileScreenLayout()),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Lock Screan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Please Enter Password',
                errorText: _errorText,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: _toggleObscure,
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitPassword,
                    child: const Text('Next'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
