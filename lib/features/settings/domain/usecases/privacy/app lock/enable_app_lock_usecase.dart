import '../../../repository/privacy/app lock/app_lock_repository.dart';

class EnableAppLockUseCase {
  final AppLockRepository repository;
  EnableAppLockUseCase(this.repository);

  Future<void> call(bool enabled) {
    return repository.enableAppLock(enabled);
  }
}
