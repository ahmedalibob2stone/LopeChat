import '../../repository/chat lock/chat_lock_repository.dart';

class UnlockChatUseCase {
  final ChatLockRepository repository;

  UnlockChatUseCase(this.repository);

  Future<void> call(String chatId) => repository.unlockChat(chatId);
}
