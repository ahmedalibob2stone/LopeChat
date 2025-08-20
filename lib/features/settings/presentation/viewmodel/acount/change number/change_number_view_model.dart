import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../domain/usecases/account/change_number/sign_In_with_phone_credential_use_case.dart';
import '../../../../domain/usecases/account/change_number/update_phone_number_useCase.dart';
import '../../../../domain/usecases/account/change_number/verify_new_phone_number_usecase.dart';
import '../../../../domain/usecases/account/change_number/verify_old_phone_number_usecase dart.dart';
import '../../../provider/account/changenumber/usecase/provider.dart';

class ChangeNumberState {
  final bool isLoading;
  final String? verificationIdOld;
  final String? verificationIdNew;

  ChangeNumberState({
    required this.isLoading,
    this.verificationIdOld,
    this.verificationIdNew,
  });

  factory ChangeNumberState.initial() => ChangeNumberState(isLoading: false);

  ChangeNumberState copyWith({
    bool? isLoading,
    String? verificationIdOld,
    String? verificationIdNew,
  }) {
    return ChangeNumberState(
      isLoading: isLoading ?? this.isLoading,
      verificationIdOld: verificationIdOld ?? this.verificationIdOld,
      verificationIdNew: verificationIdNew ?? this.verificationIdNew,
    );
  }
}

final changeNumberViewModelProvider =
StateNotifierProvider<ChangeNumberViewModel, ChangeNumberState>(
      (ref) => ChangeNumberViewModel(
    verifyOldPhoneNumberUseCase: ref.read(verifyOldPhoneNumberUseCaseProvider),
    verifyNewPhoneNumberUseCase: ref.read(verifyNewPhoneNumberUseCaseProvider),
    signInWithCredentialUseCase: ref.read(signInWithPhoneCredentialUseCaseProvider),
    updatePhoneNumberUseCase: ref.read(updatePhoneNumberUseCaseProvider),
  ),
);

class ChangeNumberViewModel extends StateNotifier<ChangeNumberState> {
  final VerifyOldPhoneNumberUseCase verifyOldPhoneNumberUseCase;
  final VerifyNewPhoneNumberUseCase verifyNewPhoneNumberUseCase;
  final SignInWithPhoneCredentialUseCase signInWithCredentialUseCase;
  final UpdatePhoneNumberUseCase updatePhoneNumberUseCase;

  ChangeNumberViewModel({
    required this.verifyOldPhoneNumberUseCase,
    required this.verifyNewPhoneNumberUseCase,
    required this.signInWithCredentialUseCase,
    required this.updatePhoneNumberUseCase,
  }) : super(ChangeNumberState.initial());

  void verifyOldNumber({
    required String phoneNumber,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      await verifyOldPhoneNumberUseCase(
        phoneNumber: phoneNumber,
        onVerificationCompleted: (PhoneAuthCredential credential) async {
          await signInWithCredentialUseCase(credential);
          onSuccess();
        },
        onVerificationFailed: (e) => onError(e.message ?? "Verification failed"),
        onCodeSent: (id, token) {
          state = state.copyWith(verificationIdOld: id);
        },
        onAutoRetrievalTimeout: (id) {
          state = state.copyWith(verificationIdOld: id);
        },
      );
    } catch (e) {
      onError(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void verifyNewNumber({
    required String phoneNumber,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      await verifyNewPhoneNumberUseCase(
        phoneNumber: phoneNumber,
        onVerificationCompleted: (PhoneAuthCredential credential) async {
          await updatePhoneNumberUseCase(credential);
          onSuccess();
        },
        onVerificationFailed: (e) => onError(e.message ?? "Verification failed"),
        onCodeSent: (id, token) {
          state = state.copyWith(verificationIdNew: id);
        },
        onAutoRetrievalTimeout: (id) {
          state = state.copyWith(verificationIdNew: id);
        },
      );
    } catch (e) {
      onError(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// ✅ التحقق من كود الـ SMS للرقم القديم (تسجيل الدخول)
  Future<void> signInWithSmsCode({
    required String smsCode,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    final verificationId = state.verificationIdOld;
    if (verificationId == null) {
      onError("Verification ID for old number is null");
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await signInWithCredentialUseCase(credential);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updatePhoneWithSmsCode({
    required String smsCode,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    final verificationId = state.verificationIdNew;
    if (verificationId == null) {
      onError("Verification ID for new number is null");
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await updatePhoneNumberUseCase(credential);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void reset() {
    state = ChangeNumberState.initial();
  }
}
