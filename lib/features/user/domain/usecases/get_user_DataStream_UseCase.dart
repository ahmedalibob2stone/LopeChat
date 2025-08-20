
import '../entities/user_entity.dart';
import '../repositories/interface_user_repository.dart';

class GetUserDataStreamUseCase {
  final IUserRepository repository;

  GetUserDataStreamUseCase(this.repository);

  Stream<UserEntity> call(String userId) {
    return repository.userData(userId);
  }
}

