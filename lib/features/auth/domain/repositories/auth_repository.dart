



import '../entities/verify_otp_entity.dart';

abstract class IAuthRepository {
  Future<bool> sendOtp(String phoneNumber);
  Future<VerifyOtpEntity?> verifyOtp(String phoneNumber, String otp);
  String? getCurrentUserId();
}
