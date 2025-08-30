
import '../repositories/interface_user_repository.dart';

class AddStatusUseCase {
  final IUserRepository repository;

  AddStatusUseCase(this.repository);

  Future<void> call(String status) {
    return repository.addStatus(status);
  }
}
