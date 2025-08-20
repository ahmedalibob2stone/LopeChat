import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecase/send_otp_usecase.dart';

import 'dart:async';

enum SendOtpStatus { initial, sending, sent, error, waiting }

class SendOtpState {
  final SendOtpStatus status;
  final String? errorMessage;
  final bool canResend;
  final Duration? waitingDuration;

  SendOtpState({
    this.status = SendOtpStatus.initial,
    this.errorMessage,
    this.canResend = true,
    this.waitingDuration,
  });

  SendOtpState copyWith({
    SendOtpStatus? status,
    String? errorMessage,
    bool? canResend,
    Duration? waitingDuration,
  }) {
    return SendOtpState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      canResend: canResend ?? this.canResend,
      waitingDuration: waitingDuration ?? this.waitingDuration,
    );
  }
}

enum VerifyOtpStatus { initial, verifying, verified, error, waiting }

class VerifyOtpState {
  final VerifyOtpStatus status;
  final String? errorMessage;
  final int remainingAttempts;
  final bool canRetry;
  final Duration? waitingDuration;

  VerifyOtpState({
    this.status = VerifyOtpStatus.initial,
    this.errorMessage,
    this.remainingAttempts = 6,
    this.canRetry = true,
    this.waitingDuration,
  });

  VerifyOtpState copyWith({
    VerifyOtpStatus? status,
    String? errorMessage,
    int? remainingAttempts,
    bool? canRetry,
    Duration? waitingDuration,
  }) {
    return VerifyOtpState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      remainingAttempts: remainingAttempts ?? this.remainingAttempts,
      canRetry: canRetry ?? this.canRetry,
      waitingDuration: waitingDuration ?? this.waitingDuration,
    );
  }
}
class SendOtpViewModel extends StateNotifier<SendOtpState> {
  final SendOtpUseCase _sendOtpUseCase;
  Timer? _resendTimer;
  static const _waitDuration = Duration(minutes: 5);

  SendOtpViewModel(this._sendOtpUseCase) : super(SendOtpState());

  Future<void> sendOtp(String phoneNumber) async {
    if (!state.canResend) return;

    state = state.copyWith(status: SendOtpStatus.sending, errorMessage: null);

    try {
      final success = await _sendOtpUseCase.execute(phoneNumber);
      if (success) {
        state = state.copyWith(status: SendOtpStatus.sent, canResend: false, waitingDuration: _waitDuration);

        _startResendCountdown();
      } else {
        state = state.copyWith(
          status: SendOtpStatus.error,
          errorMessage: 'Failed to send verification code. Please try again',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: SendOtpStatus.error,
        errorMessage: 'Connection error: ${e.toString()}',
      );
    }
  }

  void _startResendCountdown() {
    Duration remaining = _waitDuration;
    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining -= const Duration(seconds: 1);
      if (remaining <= Duration.zero) {
        timer.cancel();
        state = state.copyWith(canResend: true, waitingDuration: null);
      } else {
        state = state.copyWith(waitingDuration: remaining);
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}


