import 'dart:io';
import '../../../../common/Provider/Message_reply.dart';
import '../../../../common/enums/enum_massage.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../../user/data/user_model/user_model.dart';
import '../entities/message_entity.dart';

abstract class IChatMessageRepository {
  Future<void> sendTextMessage({
    required String text,
    required String chatId,
    required UserEntity sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  });

  Future<void> sendFileMessage({
    required File file,
    required String chatId,
    required UserEntity senderUserDate,
    required EnumData massageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  });

  Future<void> sendGIFMessage({
    required String gif,
    required String chatId,
    required UserEntity sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  });
  @override
  Future<void> sendLinkMessage({
    required String link,
    required String chatId,
    required UserEntity sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  });

  Stream<List<MessageEntity>> getStreamMessages(String chatId);

  Stream<List<MessageEntity>> getGroupChatStream(String groupId);

  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  });


  Future<void> setChatMessageSeen(
      String chatId,
      String messageId,
      );

  Future<void> markMessagesAsSeen(String chatId, String contactId);
}
