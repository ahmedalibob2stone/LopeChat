import 'package:firebase_auth/firebase_auth.dart';

import '../../../repository/account/change phone/change_number_repository.dart';

class VerifyOldPhoneNumberUseCase {
  final ChangePhoneNumberRepository repository;

  VerifyOldPhoneNumberUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String) onAutoRetrievalTimeout,
  }) {
    return repository.verifyOldPhoneNumber(
      phoneNumber: phoneNumber,
      onVerificationCompleted: onVerificationCompleted,
      onVerificationFailed: onVerificationFailed,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeout,
    );
  }
}
