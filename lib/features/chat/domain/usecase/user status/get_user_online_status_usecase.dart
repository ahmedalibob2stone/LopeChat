import '../../repository/user_status_repository.dart';

class GetUserOnlineStatusUseCase {
  final UserStatusRepository repository;

  GetUserOnlineStatusUseCase(this.repository);

  Future<bool> call(String userId) {
    return repository.getUserOnlineStatus(userId);
  }
}
