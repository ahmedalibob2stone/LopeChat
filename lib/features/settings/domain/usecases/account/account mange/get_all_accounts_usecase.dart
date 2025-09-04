

import '../../../../../user/domain/entities/user_entity.dart';
import '../../../../../user/data/user_model/user_model.dart';
import '../../../repository/account/account manage/auth_local_repository.dart';

class GetAllAccountsUseCase {
  final AuthLocalRepository repository;

  GetAllAccountsUseCase(this.repository);

  Future<List<UserEntity>> call() {
    return repository.getAllAccounts();
  }
}
