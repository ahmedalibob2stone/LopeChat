import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final IAuthRepository authRepository;

  VerifyOtpUseCase(this.authRepository);

  Future<String?> execute(String phoneNumber, String otp) {
    return authRepository.verifyOtp(phoneNumber, otp);
  }
}