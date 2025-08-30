import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/check internat/check_internat.dart';
import '../../domain/usecase/send_otp_usecase.dart';

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

class SendOtpViewModel extends StateNotifier<SendOtpState> {
  final SendOtpUseCase _sendOtpUseCase;
  Timer? _resendTimer;
  static const _waitDuration = Duration(minutes: 5);

  SendOtpViewModel(this._sendOtpUseCase) : super(SendOtpState());

  Future<void> sendOtp(String phoneNumber) async {
    if (!state.canResend) return;

    final connected = await CheckInternet.isConnected();
    if (!connected) {
      state = state.copyWith(
        status: SendOtpStatus.error,
        errorMessage: "No internet connection. Please try again.",
      );
      return;
    }

    state = state.copyWith(status: SendOtpStatus.sending, errorMessage: null);

    try {
      final success = await _sendOtpUseCase.execute(phoneNumber);
      if (success) {
        state = state.copyWith(
          status: SendOtpStatus.sent,
          canResend: false,
          waitingDuration: _waitDuration,
        );
        _startResendCountdown();
      } else {
        state = state.copyWith(
          status: SendOtpStatus.error,
          errorMessage: "Failed to send verification code. Please try again.",
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: SendOtpStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  String _mapExceptionToMessage(dynamic e) {
    final error = e.toString().toLowerCase();
    if (error.contains("network")) {
      return "Please check your internet connection.";
    } else if (error.contains("timeout")) {
      return "Connection timeout. Please try again.";
    } else if (error.contains("firebaseauthexception")) {
      return "Failed to send verification code. Please verify your number.";
    } else {
      return "An unexpected error occurred. Please try again later.";
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
