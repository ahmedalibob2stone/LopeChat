


import '../../../../../user/domain/entities/user_entity.dart';
import '../../../repository/account/account manage/auth_local_repository.dart';

class GetCurrentAccountUseCase {
  final AuthLocalRepository repository;

  GetCurrentAccountUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository.getCurrentAccount();
  }
}
