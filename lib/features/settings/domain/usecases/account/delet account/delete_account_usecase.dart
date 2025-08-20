

import '../../../repository/account/account manage/auth_local_repository.dart';
import '../../../repository/account/delet account/delete_account_repository.dart';

class DeleteAccountUseCase {
  final DeleteAccountRepository repository;
  final AuthLocalRepository _repository;
  DeleteAccountUseCase(this.repository,this._repository);

  Future<void> execute(String uid) async {
    await _repository.deleteAccount(uid);
    await repository.deleteAccount(uid);
  }
}
