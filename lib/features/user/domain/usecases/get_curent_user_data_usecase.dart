import '../entities/user_entity.dart';
import 'get_curent_user_id_usecase.dart';
import 'get_user_by_id_once_usecase.dart';

class GetCurrentUserDataUseCase {
  final GetCurrentUserIdUseCase getCurrentUserIdUseCase;
  final GetUserByIdOnceUseCase getUserByIdOnceUseCase;

  GetCurrentUserDataUseCase(this.getCurrentUserIdUseCase, this.getUserByIdOnceUseCase);

  Future<UserEntity> call() async {
    final uid = getCurrentUserIdUseCase();
    return await getUserByIdOnceUseCase(uid);
  }
}
