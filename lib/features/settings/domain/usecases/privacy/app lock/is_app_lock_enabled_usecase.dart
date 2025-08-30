import '../../../repository/privacy/app lock/app_lock_repository.dart';

class IsAppLockEnabledUseCase {
  final AppLockRepository repository;
  IsAppLockEnabledUseCase(this.repository);

  Future<bool> call() {
    return repository.isAppLockEnabled();
  }
}
