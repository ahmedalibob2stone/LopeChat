import '../repositories/interface_user_repository.dart';
import '../entities/user_entity.dart';

class GetUserByIdUseCase {
  final IUserRepository repository;

  GetUserByIdUseCase(this.repository);

  Stream<UserEntity> call(String uid) {
    return repository.getUserById(uid);
  }
}
