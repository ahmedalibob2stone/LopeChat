import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../provider/account/twostepverfication/viewmodel/provider.dart';
import '../../../../viewmodel/acount/twostep/two_step_verfication_viewmodel.dart';

class SetPinScreen extends ConsumerStatefulWidget {
  const SetPinScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends ConsumerState<SetPinScreen> {
  final TextEditingController _pinController = TextEditingController();

  void _savePin() async {
    final pin = _pinController.text.trim();
    if (pin.length == 6 && int.tryParse(pin) != null) {
      await ref.read(twoStepVerificationViewModelProvider.notifier).setPin(pin);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN set successfully')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit PIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(twoStepVerificationViewModelProvider
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set PIN'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Create a 6-digit PIN to secure your account.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Enter PIN',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePin,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.teal,
              ),
              child: const Text('Save PIN', style: TextStyle(fontSize: 18)),
            ),
            if (state.status == TwoStepStatus.error)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  state.errorMessage ?? 'An error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}