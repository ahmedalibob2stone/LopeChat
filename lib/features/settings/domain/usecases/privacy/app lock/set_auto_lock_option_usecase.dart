import '../../../repository/privacy/app lock/app_lock_repository.dart';

class SetAutoLockOptionUseCase {
  final AppLockRepository repository;
  SetAutoLockOptionUseCase(this.repository);

  Future<void> call(int option) {
    return repository.setAutoLockOption(option);
  }
}
