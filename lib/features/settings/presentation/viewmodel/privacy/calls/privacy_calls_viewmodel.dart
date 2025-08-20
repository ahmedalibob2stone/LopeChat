
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecases/privacy/calls/get_privacy_calls_usecase.dart';
import '../../../../domain/usecases/privacy/calls/update_privacy_calls_usecase.dart';

class PrivacyCallsState {
  final bool silenceUnknownCallers;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const PrivacyCallsState({
    required this.silenceUnknownCallers,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  PrivacyCallsState copyWith({
    bool? silenceUnknownCallers,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return PrivacyCallsState(
      silenceUnknownCallers: silenceUnknownCallers ?? this.silenceUnknownCallers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  factory PrivacyCallsState.initial() {
    return const PrivacyCallsState(
      silenceUnknownCallers: false,
      isLoading: false,
      errorMessage: null,
      successMessage: null,
    );
  }
}

class PrivacyCallsViewModel extends StateNotifier<PrivacyCallsState> {
  final GetPrivacyCallsUseCase getUseCase;
  final UpdatePrivacyCallsUseCase updateUseCase;

  PrivacyCallsViewModel({
    required this.getUseCase,
    required this.updateUseCase,
  }) : super(PrivacyCallsState.initial()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final result = await getUseCase();
      state = state.copyWith(silenceUnknownCallers: result.silenceUnknownCallers);
    } catch (e) {
      state = state.copyWith(errorMessage: "فشل تحميل الإعدادات.");
    }
  }

  Future<bool> toggleSilenceSetting(bool newValue) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      await updateUseCase(newValue);
      state = state.copyWith(
        silenceUnknownCallers: newValue,
        isLoading: false,
        successMessage: "تم تحديث الإعداد بنجاح ",
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "تعذر تحديث الإعدادات. حاول لاحقًا.",
      );
      return false;
    }
  }

  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }
}
