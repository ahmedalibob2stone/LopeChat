import '../repositories/interface_user_repository.dart';
import '../entities/user_entity.dart';

class GetUserByIdOnceUseCase {
  final IUserRepository repository;

  GetUserByIdOnceUseCase(this.repository);

  Future<UserEntity> call() {
    return repository.getUserByIdOnce();
  }
}
