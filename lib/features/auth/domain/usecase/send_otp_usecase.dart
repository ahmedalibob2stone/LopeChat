  import '../repositories/auth_repository.dart';

  class SendOtpUseCase {
    final IAuthRepository authRepository;

    SendOtpUseCase(this.authRepository);

    Future<bool> execute(String phoneNumber) {
      return authRepository.sendOtp(phoneNumber);
    }
  }