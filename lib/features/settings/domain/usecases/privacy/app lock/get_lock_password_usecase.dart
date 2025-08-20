import '../../../repository/privacy/app lock/app_lock_repository.dart';

class GetLockPasswordUseCase {
  final AppLockRepository repository;
  GetLockPasswordUseCase(this.repository);

  Future<String?> call() {
    return repository.getSavedPassword();
  }
}
