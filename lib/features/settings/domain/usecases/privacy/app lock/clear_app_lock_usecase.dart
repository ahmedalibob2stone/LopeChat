import '../../../repository/privacy/app lock/app_lock_repository.dart';

class ClearAppLockUseCase {
  final AppLockRepository repository;
  ClearAppLockUseCase(this.repository);

  Future<void> call() {
    return repository.clearAppLockData();
  }
}
