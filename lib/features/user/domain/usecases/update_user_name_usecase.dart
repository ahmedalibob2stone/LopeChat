import '../repositories/interface_user_repository.dart';

class UpdateUserNameUseCase {
  final IUserRepository repository;

  UpdateUserNameUseCase(this.repository);

  Future<void> call(String name) {
    return repository.updateUserName(name);
  }
}
