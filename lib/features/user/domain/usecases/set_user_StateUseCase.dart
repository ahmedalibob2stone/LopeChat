
import '../repositories/interface_user_repository.dart';

class SetUserStateUseCase {
  final IUserRepository repository;

  SetUserStateUseCase(this.repository);

  Future<void> call(String isOnline) {
    return repository.setUserState(isOnline);
  }
}
