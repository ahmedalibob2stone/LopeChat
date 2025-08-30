
import '../entities/user_entity.dart';
import '../repositories/interface_user_repository.dart';

class GetCurrentUserDataUseCase {
  final IUserRepository repository;

  GetCurrentUserDataUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository.getCurrentUserData();
  }
}
