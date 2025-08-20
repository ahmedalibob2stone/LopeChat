import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecases/account/twostepverfication/get_pin_usecase.dart';
import '../../../../domain/usecases/account/twostepverfication/get_two_step_status_usecase.dart';
import '../../../../domain/usecases/account/twostepverfication/set_pin_usecase.dart';
import '../../../../domain/usecases/account/twostepverfication/set_two_step_status_usecase.dart';



enum TwoStepStatus { initial, loading, enabled, disabled, error }

class TwoStepVerificationState {
  final TwoStepStatus status;
  final bool isEnabled;
  final String? pin;
  final String? errorMessage;

  TwoStepVerificationState({
    this.status = TwoStepStatus.initial,
    this.isEnabled = false,
    this.pin,
    this.errorMessage,
  });

  TwoStepVerificationState copyWith({
    TwoStepStatus? status,
    bool? isEnabled,
    String? pin,
    String? errorMessage,
  }) {
    return TwoStepVerificationState(
      status: status ?? this.status,
      isEnabled: isEnabled ?? this.isEnabled,
      pin: pin ?? this.pin,
      errorMessage: errorMessage,
    );
  }
}

class TwoStepVerificationViewModel extends StateNotifier<TwoStepVerificationState> {
  final GetTwoStepStatusUseCase _getStatusUseCase;
  final SetTwoStepStatusUseCase _setStatusUseCase;
  final GetPinUseCase _getPinUseCase;
  final SetPinUseCase _setPinUseCase;

  TwoStepVerificationViewModel({
    required GetTwoStepStatusUseCase getStatusUseCase,
    required SetTwoStepStatusUseCase setStatusUseCase,
    required GetPinUseCase getPinUseCase,
    required SetPinUseCase setPinUseCase,
  })  : _getStatusUseCase = getStatusUseCase,
        _setStatusUseCase = setStatusUseCase,
        _getPinUseCase = getPinUseCase,
        _setPinUseCase = setPinUseCase,
        super(TwoStepVerificationState()) {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    state = state.copyWith(status: TwoStepStatus.loading);
    try {
      final enabled = await _getStatusUseCase();
      final pin = await _getPinUseCase();
      state = state.copyWith(
        status: TwoStepStatus.initial,
        isEnabled: enabled,
        pin: pin,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(status: TwoStepStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> enableTwoStepVerification() async {
    state = state.copyWith(status: TwoStepStatus.loading);
    try {
      await _setStatusUseCase(true);
      state = state.copyWith(status: TwoStepStatus.enabled, isEnabled: true);
    } catch (e) {
      state = state.copyWith(status: TwoStepStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> disableTwoStepVerification() async {
    state = state.copyWith(status: TwoStepStatus.loading);
    try {
      await _setStatusUseCase(false);
      state = state.copyWith(status: TwoStepStatus.disabled, isEnabled: false, pin: null);
    } catch (e) {
      state = state.copyWith(status: TwoStepStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> setPin(String newPin) async {
    state = state.copyWith(status: TwoStepStatus.loading);
    try {
      await _setPinUseCase(newPin);
      state = state.copyWith(status: TwoStepStatus.enabled, pin: newPin, isEnabled: true);
    } catch (e) {
      state = state.copyWith(status: TwoStepStatus.error, errorMessage: e.toString());
    }
  }
}
