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
        AppSnackbar.showError(context, next.errorMessage!);
      }

      if (next.status == SendOtpStatus.sent) {
        AppSnackbar.showSuccess(context, "OTP sent successfully!");
        Navigator.pushNamed(
          context,
          PageConst.otp_screan,
          arguments: {
            'phoneNumber': '+${selectedCountry!.phoneCode}${phoneController.text.trim()}',
            'isFromAddAccount': false,
          },
        );
      }
    });


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
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

                  // Description
                  Text(
                    "ChatLope will need to verify your phone number",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                  // Phone input row with country picker icon
                  Row(
                    children: [
                      InkWell(
                        onTap: selectCountry,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              if (selectedCountry != null)
                                Text(
                                  '${countryFlag(selectedCountry!.countryCode)} +${selectedCountry!.phoneCode}',
                                  style: TextStyle(fontSize: 16),
                                )
                              else
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                ),
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

                  // Send OTP button / loading
                  if (state.status == SendOtpStatus.sending)
                    const Center(child: CircularProgressIndicator())
                  else
                    ButtonContainerWidget(
                      color: kkPrimaryColor,
                      text: state.canResend
                          ? 'Send OTP'
                          : 'Wait ${state.waitingDuration != null ? _formatDuration(state.waitingDuration!) : ''}',
                      onTapListener: state.canResend ? sendOtp : null,
                    ),

                  // Spacer to push content up on small screens
                  const Spacer(),
                ],
              ),
            ),
          ),
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
