import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/check internat/check_internat.dart';
import '../../domain/usecase/send_otp_usecase.dart';
import '../../domain/usecase/sign_in_with_token_usecase.dart';
import '../../domain/usecase/verify_otp_usecase.dart';

enum VerifyOtpStatus { initial, verifying, verified, error }

class VerifyOtpState {
  final VerifyOtpStatus status;
  final String? errorMessage;
  final int attemptsLeft;
  final bool canResendOtp;
  final int resendSeconds;

  const VerifyOtpState({
    this.status = VerifyOtpStatus.initial,
    this.errorMessage,
    this.attemptsLeft = 5,
    this.canResendOtp = false,
    this.resendSeconds = 0,
  });

  VerifyOtpState copyWith({
    VerifyOtpStatus? status,
    String? errorMessage,
    int? attemptsLeft,
    bool? canResendOtp,
    int? resendSeconds,
  }) {
    return VerifyOtpState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      attemptsLeft: attemptsLeft ?? this.attemptsLeft,
      canResendOtp: canResendOtp ?? this.canResendOtp,
      resendSeconds: resendSeconds ?? this.resendSeconds,
    );
  }
}

class VerifyOtpViewModel extends StateNotifier<VerifyOtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SignInWithTokenUseCase _signInWithTokenUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  Timer? _resendTimer;

  VerifyOtpViewModel(
      this._verifyOtpUseCase,
      this._signInWithTokenUseCase,
      this._sendOtpUseCase)
      : super(const VerifyOtpState());

  // ==================== Helper لتقليل التكرار ====================
  void _setError(String message) {
    if (state.status != VerifyOtpStatus.error || state.errorMessage != message) {
      state = state.copyWith(status: VerifyOtpStatus.error, errorMessage: message);
    }
  }


  bool _isValidOtp(String otp) => RegExp(r'^\d{6}$').hasMatch(otp);

  String _mapExceptionToMessage(dynamic e) {
    if (e is TimeoutException) return "Request timed out";
    if (e.toString().contains("SocketException") || e.toString().contains("network")) {
      return "No internet connection";
    }
    if (e.toString().contains("429")) return "Too many attempts, please wait";
    if (e.toString().contains("401")) return "Wrong verification code";
    return "Unexpected error occurred";
  }

  // ==================== Verify OTP ====================
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    final connected = await CheckInternet.isConnected();
    if (!connected) {
      _setError("No internet connection");
      return;
    }

    if (!_isValidOtp(otp)) {
      _setError("Invalid code format");
      return;
    }

    state = state.copyWith(status: VerifyOtpStatus.verifying, errorMessage: null);

    try {
      final result = await _verifyOtpUseCase.execute(phoneNumber, otp);

      if (result == null || result.token == null) {
        // فقط ابدأ العد إذا الاستدعاء ناجح والخادم رفض الكود
        state = state.copyWith(
          status: VerifyOtpStatus.error,
          errorMessage: "Wrong verification code",
          attemptsLeft: result?.attempts ?? state.attemptsLeft,
        );
        _startResendCountdown(); // ✅ فقط عند رفض الكود من السيرفر
      } else {
        await _signInWithTokenUseCase.execute(result.token!);
        state = state.copyWith(status: VerifyOtpStatus.verified, errorMessage: null);
      }
    } catch (e) {
      _setError(_mapExceptionToMessage(e));
    }
  }

  // ==================== Resend OTP ====================
  Future<void> resendOtp(String phoneNumber) async {
    if (state.attemptsLeft <= 0) {
      _setError("Maximum resend attempts reached");
      state = state.copyWith(canResendOtp: false);
      return;
    }

    final connected = await CheckInternet.isConnected();
    if (!connected) {
      _setError("No internet connection");
      return;
    }

    try {
      await _sendOtpUseCase.execute(phoneNumber);
      state = state.copyWith(attemptsLeft: state.attemptsLeft - 1);
      _startResendCountdown();
    } catch (e) {
      _setError("Failed to resend OTP");
    }
  }

  // ==================== Countdown Timer ====================
  void _startResendCountdown() {
    state = state.copyWith(resendSeconds: 60, canResendOtp: false, errorMessage: null);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendSeconds > 0) {
        state = state.copyWith(resendSeconds: state.resendSeconds - 1);
      } else {
        if (state.canResendOtp != true || state.errorMessage != null) {
          state = state.copyWith(canResendOtp: true, errorMessage: null);
        }
        timer.cancel();
      }
    });
  }

  // ==================== Reset ====================
  void reset() {
    state = const VerifyOtpState();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
