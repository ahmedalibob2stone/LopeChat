import '../../../repository/privacy/app lock/app_lock_repository.dart';

class AuthenticateWithBiometricsUseCase {
  final AppLockRepository repository;
  AuthenticateWithBiometricsUseCase(this.repository);

  Future<bool> call() {
    return repository.authenticateWithBiometrics();
  }
}
