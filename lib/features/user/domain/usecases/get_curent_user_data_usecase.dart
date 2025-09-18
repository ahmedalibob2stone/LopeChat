import '../entities/user_entity.dart';
import 'get_curent_user_id_usecase.dart';
import 'get_user_by_id_once_usecase.dart';

class GetCurrentUserDataUseCase {
  final GetUserByIdOnceUseCase getUserByIdOnceUseCase;

  GetCurrentUserDataUseCase(this.getUserByIdOnceUseCase);

  Future<UserEntity> call() async {
    return await getUserByIdOnceUseCase();
  }
}
