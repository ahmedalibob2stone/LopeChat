import '../../domain/entities/user_entity.dart';
import '../repositories/interface_user_repository.dart';

class GetCurrentUserUseCase {
  final IUserRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserEntity?> call() async {
    final uid = await repository.getCurrentUserId();
    if (uid == null) return null;
    return await repository.getUserByIdOnce(uid);
  }
}
