import '../../repository/block/block_user_repository.dart';

class ClearMessagesUseCase {
  final BlockUserRepository repository;

  ClearMessagesUseCase(this.repository);

  Future<void> call({
    required String currentUserId,
    required String chatId,
  }) {
    return repository.clearMessages(
      currentUserId: currentUserId,
      chatId: chatId,
    );
  }
}
