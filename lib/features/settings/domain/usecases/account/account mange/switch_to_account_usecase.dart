
import '../../../repository/account/account manage/auth_local_repository.dart';

class SwitchToAccountUseCase {
  final AuthLocalRepository repository;

  SwitchToAccountUseCase(this.repository);

  Future<void> call(String uid) {
    return repository.switchToAccount(uid);
  }
}
