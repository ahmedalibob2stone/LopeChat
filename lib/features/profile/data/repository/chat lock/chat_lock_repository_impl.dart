import '../../datasource/chat lock/chat_lock_local_datasource.dart';
import '../../../domain/repository/chat lock/chat_lock_repository.dart';

class ChatLockRepositoryImpl implements ChatLockRepository {
  final ChatLockLocalDataSource localDataSource;

  ChatLockRepositoryImpl({required this.localDataSource});

  @override
  Future<void> lockChat(String chatId) => localDataSource.lockChat(chatId);

  @override
  Future<void> unlockChat(String chatId) => localDataSource.unlockChat(chatId);

  @override
  Future<bool> isChatLocked(String chatId) => localDataSource.isChatLocked(chatId);
}
