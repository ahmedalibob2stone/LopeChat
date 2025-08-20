import '../../repository/user_status_repository.dart';

class UpdateUserusUseCase {
  final UserStatusRepository repository;

  UpdateUserusUseCase(this.repository);

  Future<void> call({required bool isOnline}) {
    return repository.updateUserStatus(isOnline: isOnline);
  }
}
