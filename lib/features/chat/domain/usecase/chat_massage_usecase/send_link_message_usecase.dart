import '../../../../../common/Provider/Message_reply.dart';
import '../../../../user/domain/entities/user_entity.dart';
import '../../repository/chat_message_repository.dart';

class SendLinkMessageUseCase {
  final IChatMessageRepository repository;

  SendLinkMessageUseCase(this.repository);

  Future<void> call({
    required String link,
    required String chatId,
    required UserEntity sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) {
    return repository.sendLinkMessage(
      link: link,
      chatId: chatId,
      sendUser: sendUser,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );
  }
}
