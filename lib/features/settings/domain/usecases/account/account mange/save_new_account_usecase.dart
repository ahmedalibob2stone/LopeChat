
import '../../../../../user/domain/entities/user_entity.dart';
import '../../../../../user/model/user_model/user_model.dart';
import '../../../repository/account/account manage/auth_local_repository.dart';


class SaveNewAccountUseCase {
  final AuthLocalRepository repository;

  SaveNewAccountUseCase(this.repository);

  Future<void> call(UserEntity user) {
    return repository.saveNewAccount(user);
  }
}
