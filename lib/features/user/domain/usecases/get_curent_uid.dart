import '../repositories/interface_user_repository.dart';

class AddStatusUseCase {
  final IUserRepository repository;

  AddStatusUseCase(this.repository);

  Future<void> call() {
    return repository.getCurrentUserId();
  }
}