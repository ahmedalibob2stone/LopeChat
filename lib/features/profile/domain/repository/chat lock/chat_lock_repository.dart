abstract class ChatLockRepository {
  Future<void> lockChat(String chatId);
  Future<void> unlockChat(String chatId);
  Future<bool> isChatLocked(String chatId);
}
