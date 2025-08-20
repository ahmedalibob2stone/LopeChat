
import '../../repository/chat_message_repository.dart';

class MarkMessagesAsSeenUseCase {
  final IChatMessageRepository repository;

  MarkMessagesAsSeenUseCase(this.repository);

  Future<void> execute(String chatId, String contactId) async {
    await repository.markMessagesAsSeen(chatId, contactId);
  }
}