import '../../../repository/privacy/app lock/app_lock_repository.dart';

class GetAutoLockOptionUseCase {
  final AppLockRepository repository;
  GetAutoLockOptionUseCase(this.repository);

  Future<int> call() {
    return repository.getAutoLockOption();
  }
}
