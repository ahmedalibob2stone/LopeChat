import '../../entities/message_entity.dart';
import '../../repository/chat_message_repository.dart';

class GetGroupChatStreamUseCase {
  final IChatMessageRepository repository;

  GetGroupChatStreamUseCase(this.repository);

  Stream<List<MessageEntity>> execute(String groupId) {
    return repository.getGroupChatStream(groupId);
  }
}