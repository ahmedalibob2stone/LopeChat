import 'package:firebase_auth/firebase_auth.dart';

import '../../../../domain/repository/account/change phone/change_number_repository.dart';
import '../../../datasource/account/change phone/change_phone_number_remote_datasource.dart';

class ChangePhoneNumberRepositoryImpl implements ChangePhoneNumberRepository {
  final ChangePhoneNumberRemoteDataSource remoteDataSource;

  ChangePhoneNumberRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> verifyOldPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String) onAutoRetrievalTimeout,
  }) {
    return remoteDataSource.verifyOldPhoneNumber(
      phoneNumber: phoneNumber,
      onVerificationCompleted: onVerificationCompleted,
      onVerificationFailed: onVerificationFailed,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeout,
    );
  }

  @override
  Future<void> verifyNewPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String) onAutoRetrievalTimeout,
  }) {
    return remoteDataSource.verifyNewPhoneNumber(
      phoneNumber: phoneNumber,
      onVerificationCompleted: onVerificationCompleted,
      onVerificationFailed: onVerificationFailed,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeout,
    );
  }

  @override
  Future<UserCredential> signInWithPhoneCredential(PhoneAuthCredential credential) {
    return remoteDataSource.signInWithPhoneCredential(credential);
  }

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential credential) {
    return remoteDataSource.updatePhoneNumber(credential);
  }
}
