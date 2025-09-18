
import '../../entities/chat message/message_entity.dart';
import '../../repository/chat_message_repository.dart';

class GetStreamMessagesUseCase {
  final IChatMessageRepository repository;

  GetStreamMessagesUseCase(this.repository);

  Stream<List<MessageEntity>> execute(String chatId ) {
    return repository.getStreamMessages(chatId);
  }
}
