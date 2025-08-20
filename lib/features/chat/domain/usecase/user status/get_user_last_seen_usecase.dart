import '../../repository/user_status_repository.dart';

class GetUserLastSeenUseCase {
  final UserStatusRepository repository;

  GetUserLastSeenUseCase(this.repository);

  Future<String> call(String userId) {
    return repository.getUserLastSeen(userId);
  }
}
