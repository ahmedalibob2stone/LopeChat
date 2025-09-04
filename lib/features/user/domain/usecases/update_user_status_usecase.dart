import '../repositories/interface_user_repository.dart';

class UpdateUserStatusUseCase {
  final IUserRepository repository;

  UpdateUserStatusUseCase(this.repository);

  Future<void> call(String statu) {
    return repository.updateUserStatu(statu);
  }
}
