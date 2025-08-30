import '../../repository/chat lock/chat_lock_repository.dart';

class LockChatUseCase {
  final ChatLockRepository repository;

  LockChatUseCase(this.repository);

  Future<void> call(String chatId) => repository.lockChat(chatId);
}
