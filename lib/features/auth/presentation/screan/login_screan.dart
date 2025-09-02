import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/Buttom_container.dart';
import '../../../../common/widgets/Form_Container.dart';
import '../../../../common/widgets/helper snackbar/helper_snackbar.dart';
import '../../../../constant.dart';
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

  String countryFlag(String countryCode) {
    return countryCode.toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
          (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
  }

  void sendOtp() {
    final phoneNumber = phoneController.text.trim();
    if (selectedCountry == null || phoneNumber.isEmpty) {
      AppSnackbar.showError(context, 'Please enter a valid phone number');
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
        if (previous?.errorMessage != next.errorMessage) {
          AppSnackbar.showError(context, next.errorMessage!);
        }
      }

      if (next.status == SendOtpStatus.sent) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushNamed(
            context,
            PageConst.otp_screan,
            arguments: {
              'phoneNumber': '+${selectedCountry!.phoneCode}${phoneController.text.trim()}',
              'isFromAddAccount': false,
            },
          );
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Center(
                child: Text(
                  "Enter your phone number",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Text(
                "ChatLope will need to verify your phone number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Row(
                children: [
                  InkWell(
                    onTap: selectCountry,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (selectedCountry != null)
                            Text(
                              '${countryFlag(selectedCountry!.countryCode)} +${selectedCountry!.phoneCode}',
                              style: const TextStyle(fontSize: 16),
                            )
                          else
                            const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FormContainerWidget(
                      controller: phoneController,
                      hintText: 'Phone number',
                      inputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              state.status == SendOtpStatus.sending
                  ? const Center(child: CircularProgressIndicator())
                  : ButtonContainerWidget(
                color: kkPrimaryColor,
                text: 'Send OTP',
                onTapListener: sendOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
