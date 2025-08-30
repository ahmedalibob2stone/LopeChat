import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/helper snackbar/helper_snackbar.dart';
import '../providers/viewmodel/verify_opt_vm.dart';
import '../viewmodels/verify_opt_viewmodel.dart'; // Helper Snackbar Class

class VerifyScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final bool isFromAddAccount;
  const VerifyScreen({Key? key, required this.phoneNumber, required this.isFromAddAccount}) : super(key: key);

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  final TextEditingController otpController = TextEditingController();
  @override
  void initState() {
    super.initState();
    ref.read(verifyOtpViewModelProvider.notifier).reset();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _verifyOTP(String code) {
    if (code.length == 6) {
      ref.read(verifyOtpViewModelProvider.notifier).verifyOtp(widget.phoneNumber, code.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verifyOtpViewModelProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    ref.listen<VerifyOtpState>(verifyOtpViewModelProvider, (previous, next) {
      if (next.status == VerifyOtpStatus.error && next.errorMessage != null) {
        AppSnackbar.showError(context, next.errorMessage!);
      }
      if (next.status == VerifyOtpStatus.verified) {


        AppSnackbar.showSuccess(context, "OTP verified successfully");
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(context, '/home');
        });

      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: screenHeight * 0.12,
                color: Colors.blueAccent,
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.06),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Verify Your Phone Number",
                      style: TextStyle(fontSize: screenHeight * 0.025, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "We have sent an SMS with a 6-digit code to ${widget.phoneNumber}",
                      style: TextStyle(fontSize: screenHeight * 0.018, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    TextField(
                      controller: otpController,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(letterSpacing: 12, fontSize: screenHeight * 0.03),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: _verifyOTP, // المعالجة فور إدخال 6 أرقام
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    if (state.status == VerifyOtpStatus.verifying)
                      CircularProgressIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
