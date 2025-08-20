abstract class UserStatusRepository {
  Future<void> updateUserStatus({required bool isOnline});

  Future<String> getUserLastSeen(String userId);

  Future<String> getUserOnlineStatus(String userId);
}
