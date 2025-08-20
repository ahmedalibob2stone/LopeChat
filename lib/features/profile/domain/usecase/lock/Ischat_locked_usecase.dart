import '../../repository/chat lock/chat_lock_repository.dart';

class IsChatLockedUseCase {
  final ChatLockRepository repository;

  IsChatLockedUseCase(this.repository);

  Future<bool> call(String chatId) => repository.isChatLocked(chatId);
}
