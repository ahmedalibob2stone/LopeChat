
import '../../../repository/account/account manage/auth_local_repository.dart';

class DeleteAccountLocalUseCase {
  final AuthLocalRepository repository;

  DeleteAccountLocalUseCase(this.repository);

  Future<void> call(String uid) {
    return repository.deleteAccount(uid);
  }
}
