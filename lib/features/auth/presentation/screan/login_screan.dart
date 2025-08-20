import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/viewmodel/send_opt_vm.dart';
import '../viewmodels/send_otp_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country? selectedCountry;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void selectCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country;
        });
      },
    );
  }

  void sendOtp() {
    final phoneNumber = phoneController.text.trim();

    if (selectedCountry == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    final fullPhone = '+${selectedCountry!.phoneCode}$phoneNumber';

    ref.read(sendOtpViewModelProvider.notifier).sendOtp(fullPhone);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sendOtpViewModelProvider);

    ref.listen<SendOtpState>(sendOtpViewModelProvider, (previous, next) {
      if (next.status == SendOtpStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }

      if (next.status == SendOtpStatus.sent) {
        Navigator.pushNamed(
          context,
          '/verify',
          arguments: {
            'phoneNumber': '+${selectedCountry!.phoneCode}${phoneController.text.trim()}',
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Enter your phone number')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextButton(
              onPressed: selectCountry,
              child: Text(
                selectedCountry != null
                    ? 'Country: ${selectedCountry!.name} (+${selectedCountry!.phoneCode})'
                    : 'Pick Your Country',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            Row(
              children: [
                if (selectedCountry != null)
                  Text('+${selectedCountry!.phoneCode}'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'Phone number'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (state.status == SendOtpStatus.sending)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: state.canResend ? sendOtp : null,
                child: state.canResend
                    ? const Text('Send OTP')
                    : Text('انتظر ${state.waitingDuration != null ? _formatDuration(state.waitingDuration!) : ''}'),
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
