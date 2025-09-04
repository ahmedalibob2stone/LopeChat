import '../repositories/interface_user_repository.dart';
import '../entities/user_entity.dart';

class GetMyDataStreamUseCase {
  final IUserRepository repository;

  GetMyDataStreamUseCase(this.repository);

  Stream<UserEntity?> call() {
    return repository.myData();
  }
}
