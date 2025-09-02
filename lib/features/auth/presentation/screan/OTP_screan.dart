import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/helper snackbar/helper_snackbar.dart';
import '../../../../constant.dart';
import '../providers/viewmodel/verify_opt_vm.dart';
import '../viewmodels/verify_opt_viewmodel.dart';

class VerifyScreen extends ConsumerWidget {
  const VerifyScreen({
    Key? key,
    required this.phoneNumber,
    required this.isFromAddAccount,
  }) : super(key: key);

  final String phoneNumber;
  final bool isFromAddAccount;

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Center(
        child: Text(
          "Verifying your number",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInput(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 6,
        style: const TextStyle(
          letterSpacing: 4,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '',
          hintText: '• • • • • •',
          hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kkPrimaryColor, width: 2),
          ),
        ),
        onChanged: (val) {
          if (val.length == 6) {
            ref
                .read(verifyOtpViewModelProvider.notifier)
                .verifyOtp(phoneNumber, val.trim());
          }
        },
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Consumer(
      builder: (context, ref, _) {
        final errorMessage = ref.watch(
          verifyOtpViewModelProvider.select((state) => state.errorMessage),
        );

        if (errorMessage == null || errorMessage.isEmpty) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }


  Widget _buildResendSection(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final seconds = ref.watch(
          verifyOtpViewModelProvider.select((s) => s.resendSeconds),
        );
        final canResend = ref.watch(
          verifyOtpViewModelProvider.select((s) => s.canResendOtp),
        );

        return seconds > 0
            ? Text(
          "Resend code in ${seconds}s",
          style: const TextStyle(color: Colors.grey),
        )
            : TextButton(
          onPressed: canResend
              ? () => ref
              .read(verifyOtpViewModelProvider.notifier)
              .resendOtp(phoneNumber)
              : null,
          child: const Text(
            "Resend OTP",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kkPrimaryColor,
            ),
          ),
        );
      },
    );
  }


  Widget _buildVerifyingIndicator() {
    return Consumer(
      builder: (context, ref, _) {
        final isVerifying = ref.watch(
          verifyOtpViewModelProvider.select(
                  (s) => s.status == VerifyOtpStatus.verifying),
        );

        if (!isVerifying) return const SizedBox();

        return const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<VerifyOtpState>(
      verifyOtpViewModelProvider,
          (previous, next) {
        // عند وجود خطأ
        if (next.status == VerifyOtpStatus.error &&
            next.errorMessage != null &&
            next.errorMessage!.isNotEmpty) {
          AppSnackbar.showError(context, next.errorMessage!);
        }

        // عند النجاح (OTP Verified)
        if (next.status == VerifyOtpStatus.verified) {
          AppSnackbar.showSuccess(context, "OTP Verified Successfully ✅");

           Future.microtask(() {
             Navigator.pushNamedAndRemoveUntil(
               context,
               PageConst.user_information,
                   (route) => false,
             );

           });
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.09),
        children: [
          _buildHeader(context),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'We have sent an SMS with a code.',
                style: TextStyle(
                  color: kkPrimaryColor,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              _buildOtpInput(context, ref),
              _buildVerifyingIndicator(),
              _buildErrorMessage(),
              const SizedBox(height: 16),
              _buildResendSection(context, ),
            ],
          ),
        ],
      ),
    );
  }
}
