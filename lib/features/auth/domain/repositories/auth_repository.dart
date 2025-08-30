



abstract class IAuthRepository {
  Future<bool> sendOtp(String phoneNumber);
  Future<String?> verifyOtp(String phoneNumber, String otp);
  String? getCurrentUserId();
}
