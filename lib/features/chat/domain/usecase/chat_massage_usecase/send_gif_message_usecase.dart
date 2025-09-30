import 'package:flutter/material.dart';

import '../../../../../common/Provider/Message_reply.dart';
import '../../../../user/domain/entities/user_entity.dart';
import '../../repository/chat_message_repository.dart';

class SendGifMessageUseCase {
  final IChatMessageRepository repository;

  SendGifMessageUseCase(this.repository);

  Future<String> execute({
    required String gif,
    required String chatId,
    required UserEntity sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    final serverMessageId = await   repository.sendGIFMessage(
      gif: gif,
      chatId: chatId,
      sendUser: sendUser,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );
    return serverMessageId;
  }
}