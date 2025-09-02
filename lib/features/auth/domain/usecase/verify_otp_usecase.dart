import '../entities/verify_otp_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final IAuthRepository authRepository;

  VerifyOtpUseCase(this.authRepository);

  Future<VerifyOtpEntity?> execute(String phoneNumber, String otp) {
    return authRepository.verifyOtp(phoneNumber, otp);
  }
}
