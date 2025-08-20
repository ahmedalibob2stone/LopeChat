import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../constant.dart';
import '../../../../provider/account/twostepverfication/viewmodel/provider.dart';
import '../../../../viewmodel/acount/twostep/two_step_verfication_viewmodel.dart';


class TwoStepVerificationScreen extends ConsumerWidget {
  const TwoStepVerificationScreen({Key? key}) : super(key: key);

  void _navigateToSetPin(BuildContext context) {

    Navigator.pushNamed(context, PageConst.SetPinScreen);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(twoStepVerificationViewModelProvider);
    final vm = ref.read(twoStepVerificationViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-step verification'),
        backgroundColor: Colors.teal,
      ),
      body: state.status == TwoStepStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.teal),

            const SizedBox(height: 24),

            const Text(
              'Enter a PIN to add extra security to your account.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            Text(
              state.pin == null || state.pin!.isEmpty ? '******' : state.pin!.replaceAll(RegExp(r'.'), '*'),
              style: const TextStyle(
                fontSize: 40,
                letterSpacing: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'This PIN will be required to verify your account.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () => _navigateToSetPin(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.teal,
              ),
              child: const Text('Enable', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}


