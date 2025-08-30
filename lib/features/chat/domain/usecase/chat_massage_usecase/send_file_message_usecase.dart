import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../common/Provider/Message_reply.dart';
import '../../../../../common/enums/enum_massage.dart';
import '../../../../user/domain/entities/user_entity.dart';
import '../../repository/chat_message_repository.dart';

class SendFileMessageUseCase {
  final IChatMessageRepository repository;

  SendFileMessageUseCase(this.repository);

  Future<void> execute({
    required File file,
    required String chatId,
    required UserEntity senderUserDate,
    required EnumData massageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    await repository.sendFileMessage(
      file: file,
      chatId: chatId,
      senderUserDate: senderUserDate,
      massageEnum: massageEnum,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );
  }
}