import 'dart:io';

import '../../../../common/Provider/Message_reply.dart';
import '../../../../common/enums/enum_massage.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../../user/data/user_model/user_model.dart';
import '../../domain/repository/chat_message_repository.dart';
import '../datasorce/chat_massage_remote_datasource.dart';
import '../model/massage/massage_model.dart';


class ChatMessageRepositoryImpl implements IChatMessageRepository {
  final ChatMessageRemoteDataSource remoteDataSource;

  ChatMessageRepositoryImpl( {required this.remoteDataSource});

  @override
  Future<void> sendTextMessage({
    required String text,
    required String chatId,
    required UserEntity  sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) {
    final userModel = UserModel.fromEntity(sendUser);

    return remoteDataSource.sendTextMessage(
      text: text,
      chatId: chatId,
      sendUser: userModel,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );
  }
  @override
  Future<void> sendLinkMessage({
    required String link,
    required String chatId,
    required UserEntity sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  })async{
    final userModel = UserModel.fromEntity(sendUser);

    return remoteDataSource.sendLinkMessage(link: link,
        chatId: chatId, sendUser: userModel, messageReply: messageReply, isGroupChat: isGroupChat);
  }
  @override
  Future<void> sendFileMessage({
    required File file,
    required String chatId,
    required UserEntity  senderUserDate,
    required EnumData massageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) {
    final userModel = UserModel.fromEntity(senderUserDate);

    return remoteDataSource.sendFileMessage(
      file: file,
      chatId: chatId,
      senderUserDate: userModel,
      massageEnum: massageEnum,
      messageReply: messageReply!,
      isGroupChat: isGroupChat,
    );
  }

  @override
  Future<void> sendGIFMessage({
    required String gif,
    required String chatId,
    required UserEntity sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) {
    final userModel = UserModel.fromEntity(sendUser);

    return remoteDataSource.sendGIFMessage(
      gif: gif,
      chatId: chatId,
      sendUser: userModel,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );
  }

  @override
  Stream<List<MessageModel>> getStreamMessages(String chatId) {
    return remoteDataSource.getStreamMessages(chatId);

  }

  @override
  Stream<List<MessageModel>> getGroupChatStream(String groupId) {
    return remoteDataSource.getGroupChatStream(groupId);
  }
  @override
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) {
    return remoteDataSource.deleteMessage(
      chatId: chatId,
      messageId: messageId,
    );
  }



  @override
  Future<void> setChatMessageSeen(
      String chatId,
      String messageId,
      ) {
    return remoteDataSource.setChatMessageSeen(
   chatId: chatId, messageId: messageId,
    );
  }

  @override
  Future<void> markMessagesAsSeen(String chatId, String contactId) {
    return remoteDataSource.markMessagesAsSeen(chatId, contactId);
  }
}
