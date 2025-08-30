
import '../entities/user_entity.dart';
import '../repositories/interface_user_repository.dart';

class GetUserByIdUseCase {
  final IUserRepository repository;

  GetUserByIdUseCase(this.repository);

  Stream<UserEntity> execute(String uid) {
    return repository.getUserById(uid);
  }

}
