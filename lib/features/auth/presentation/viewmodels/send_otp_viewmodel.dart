import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/check internat/check_internat.dart';
import '../../domain/usecase/send_otp_usecase.dart';

enum SendOtpStatus { initial, sending, sent, error }

class SendOtpState {
  final SendOtpStatus status;
  final String? errorMessage;

  const SendOtpState({
    this.status = SendOtpStatus.initial,
    this.errorMessage,
  });

  SendOtpState copyWith({
    SendOtpStatus? status,
    String? errorMessage,
  }) {
    return SendOtpState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class SendOtpViewModel extends StateNotifier<SendOtpState> {
  final SendOtpUseCase _sendOtpUseCase;

  SendOtpViewModel(this._sendOtpUseCase) : super(const SendOtpState());

  Future<void> sendOtp(String phoneNumber) async {
    final connected = await CheckInternet.isConnected();
    if (!connected) {
      _setError("No internet connection. Please try again.");
      return;
    }
    state = state.copyWith(status: SendOtpStatus.sending, errorMessage: null);

    try {
      final success = await _sendOtpUseCase.execute(phoneNumber);
      if (success) {
        state = state.copyWith(status: SendOtpStatus.sent, errorMessage: null);
      } else {
        _setError("Failed to send verification code. Please check your number.");
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setError(String message) {
    state = state.copyWith(status: SendOtpStatus.error, errorMessage: message);
  }

  String _mapExceptionToMessage(dynamic e) {
    final error = e.toString().toLowerCase();
    if (error.contains("network") || error.contains("socket")) {
      return "No internet connection. Please try again.";
    } else if (error.contains("timeout")) {
      return "Connection timeout. Please try again.";
    } else if (error.contains("firebaseauthexception")) {
      return "Failed to send verification code. Please verify your number.";
    } else {
      return "An unexpected error occurred. Please try again later.";
    }
  }
}
