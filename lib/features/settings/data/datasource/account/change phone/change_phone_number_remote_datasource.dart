import 'package:firebase_auth/firebase_auth.dart';

class ChangePhoneNumberRemoteDataSource  {
  final FirebaseAuth _auth;

  ChangePhoneNumberRemoteDataSource({required FirebaseAuth firebaseAuth})
      : _auth = firebaseAuth;

  Future<void> verifyOldPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String) onAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onAutoRetrievalTimeout,
    );
  }

  Future<void> verifyNewPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String) onAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithPhoneCredential(PhoneAuthCredential credential) {
    return _auth.signInWithCredential(credential);
  }

  Future<void> updatePhoneNumber(PhoneAuthCredential credential) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePhoneNumber(credential);
    } else {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No currently signed-in user.',
      );
    }
  }
}
