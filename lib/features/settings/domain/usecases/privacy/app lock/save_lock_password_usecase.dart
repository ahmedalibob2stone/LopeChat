import '../../../repository/privacy/app lock/app_lock_repository.dart';

class SaveLockPasswordUseCase {
  final AppLockRepository repository;
  SaveLockPasswordUseCase(this.repository);

  Future<void> call(String password) {
    return repository.savePassword(password);
  }
}
