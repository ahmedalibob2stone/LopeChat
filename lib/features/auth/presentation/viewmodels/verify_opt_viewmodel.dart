import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lopechat/features/auth/presentation/viewmodels/send_otp_viewmodel.dart';

import '../../domain/usecase/sign_in_with_token_usecase.dart';
import '../../domain/usecase/verify_otp_usecase.dart';

class VerifyOtpViewModel extends StateNotifier<VerifyOtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SignInWithTokenUseCase _signInWithTokenUseCase;

  static const int maxAttempts = 6;
  Timer? _retryTimer;
  static const _waitDuration = Duration(minutes: 5);

  VerifyOtpViewModel(this._verifyOtpUseCase, this._signInWithTokenUseCase) : super(VerifyOtpState());

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    if (!state.canRetry) return;

    if (!_isValidOtp(otp)) {
      state = state.copyWith(
        status: VerifyOtpStatus.error,
        errorMessage: 'Incorrect verification code',
      );
      return;
    }

    state = state.copyWith(status: VerifyOtpStatus.verifying, errorMessage: null);

    try {
      final token = await _verifyOtpUseCase.execute(phoneNumber, otp);

      if (token == null) {
        final attemptsLeft = state.remainingAttempts - 1;

        if (attemptsLeft <= 0) {
          _startRetryCountdown();
          state = state.copyWith(
            status: VerifyOtpStatus.waiting,
            errorMessage: 'Too many attempts, please wait',
            remainingAttempts: 0,
            canRetry: false,
            waitingDuration: _waitDuration,
          );
        } else {
          state = state.copyWith(
            status: VerifyOtpStatus.error,
            errorMessage: 'Invalid verification code',
            remainingAttempts: attemptsLeft,
          );
        }
      } else {
        await _signInWithTokenUseCase.execute(token);

        state = state.copyWith(
          status: VerifyOtpStatus.verified,
          errorMessage: null,
          remainingAttempts: maxAttempts,
          canRetry: true,
          waitingDuration: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: VerifyOtpStatus.error,
        errorMessage: 'Connection error: ${e.toString()}',
      );
    }
  }

  void _startRetryCountdown() {
    Duration remaining = _waitDuration;
    _retryTimer?.cancel();

    _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining -= const Duration(seconds: 1);
      if (remaining <= Duration.zero) {
        timer.cancel();
        state = state.copyWith(canRetry: true, waitingDuration: null, remainingAttempts: maxAttempts);
      } else {
        state = state.copyWith(waitingDuration: remaining);
      }
    });
  }

  bool _isValidOtp(String otp) {
    final regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(otp);
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }
}
