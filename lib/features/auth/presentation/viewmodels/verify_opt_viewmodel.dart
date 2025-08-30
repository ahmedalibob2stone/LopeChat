import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/check internat/check_internat.dart';
import '../../domain/usecase/sign_in_with_token_usecase.dart';
import '../../domain/usecase/verify_otp_usecase.dart';

enum VerifyOtpStatus {
  initial,
  verifying,
  verified,
  error,
}

class VerifyOtpState {
  final VerifyOtpStatus status;
  final String? errorMessage;

  const VerifyOtpState({
    this.status = VerifyOtpStatus.initial,
    this.errorMessage,
  });

  VerifyOtpState copyWith({
    VerifyOtpStatus? status,
    String? errorMessage,
  }) {
    return VerifyOtpState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class VerifyOtpViewModel extends StateNotifier<VerifyOtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SignInWithTokenUseCase _signInWithTokenUseCase;

  VerifyOtpViewModel(
      this._verifyOtpUseCase,
      this._signInWithTokenUseCase,
      ) : super(const VerifyOtpState());

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    final connected = await CheckInternet.isConnected();
    if (!connected) {
      state = state.copyWith(
        status: VerifyOtpStatus.error,
        errorMessage: "No internet connection",
      );
      return;
    }

    // Check OTP format
    if (!_isValidOtp(otp)) {
      state = state.copyWith(
        status: VerifyOtpStatus.error,
        errorMessage: "Invalid code format",
      );
      return;
    }

    // Enter verifying state
    state = state.copyWith(
      status: VerifyOtpStatus.verifying,
      errorMessage: null,
    );

    try {
      final token = await _verifyOtpUseCase.execute(phoneNumber, otp);

      if (token == null) {
        state = state.copyWith(
          status: VerifyOtpStatus.error,
          errorMessage: "Wrong verification code",
        );
      } else {
        await _signInWithTokenUseCase.execute(token);
        state = state.copyWith(
          status: VerifyOtpStatus.verified,
          errorMessage: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: VerifyOtpStatus.error,
        errorMessage: _mapExceptionToMessage(e),
      );
    }
  }

  bool _isValidOtp(String otp) {
    final regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(otp);
  }

  String _mapExceptionToMessage(dynamic e) {
    if (e is TimeoutException) {
      return "Request timed out";
    } else if (e.toString().contains("429")) {
      return "Too many attempts, please wait before retrying";
    } else if (e.toString().contains("401")) {
      return "Wrong verification code";
    } else if (e.toString().contains("network")) {
      return "Network error";
    } else {
      return "Unexpected error occurred";
    }
  }
}
