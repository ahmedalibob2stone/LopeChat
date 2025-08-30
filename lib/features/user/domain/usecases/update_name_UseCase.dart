
import '../repositories/interface_user_repository.dart';

class UpdateNameUseCase {
  final IUserRepository repository;

  UpdateNameUseCase(this.repository);

  Future<void> call(String name) {
    return repository.updateName(name);
  }
}
