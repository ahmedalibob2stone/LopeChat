import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/viewmodel/verify_opt_vm.dart';
import '../viewmodels/send_otp_viewmodel.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final bool isFromAddAccount;
  const VerifyScreen({Key? key, required this.phoneNumber, required  this.isFromAddAccount}) : super(key: key);

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void verifyOTP(String code) {
    if (code.length == 6) {
      ref.read(verifyOtpViewModelProvider.notifier).verifyOtp(widget.phoneNumber, code.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verifyOtpViewModelProvider);

    ref.listen<VerifyOtpState>(verifyOtpViewModelProvider, (previous, next) {
      if (next.status == VerifyOtpStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (next.status == VerifyOtpStatus.verified) {
        // نفذ التنقل أو إظهار شاشة المستخدم بناءً على الحالة عندك
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Number')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('We have sent an SMS with a code.'),
            TextField(
              controller: otpController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(counterText: ''),
              onChanged: verifyOTP,
            ),
            const SizedBox(height: 20),
            if (state.status == VerifyOtpStatus.verifying)
              const CircularProgressIndicator(),
            if (!state.canRetry)
              Text(
                'wait ${state.waitingDuration != null ? _formatDuration(state.waitingDuration!) : ''}   before retry',
                style: const TextStyle(color: Colors.orange),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
