import 'package:firebase_auth/firebase_auth.dart';

abstract class ChangePhoneNumberRepository {
  @override
  Future<void> verifyOldPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String) onAutoRetrievalTimeout,
  })
  async {}
  Future<void> verifyNewPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String) onAutoRetrievalTimeout,
  })async {}
  Future<UserCredential> signInWithPhoneCredential(PhoneAuthCredential credential);
  Future<void> updatePhoneNumber(PhoneAuthCredential credential);
}
