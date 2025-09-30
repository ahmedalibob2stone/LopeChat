import '../../../../../common/Provider/Message_reply.dart';
import '../../../../user/domain/entities/user_entity.dart';
import '../../repository/chat_message_repository.dart';

class SendTextMessageUseCase {
  final IChatMessageRepository repository;

  SendTextMessageUseCase(this.repository);

  Future<String> execute({
    required String text,
    required String chatId,
    required UserEntity sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    final serverMessageId = await   repository.sendTextMessage(
      text: text,
      chatId: chatId,
      sendUser: sendUser,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );
    return serverMessageId;

  }

}
