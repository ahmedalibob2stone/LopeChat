import 'package:flutter/material.dart';

import '../../repository/chat_message_repository.dart';

class SetChatMessageSeenUseCase {
  final IChatMessageRepository repository;

  SetChatMessageSeenUseCase(this.repository);

  Future<void> execute( String chatId, String messageId) async {
    await repository.setChatMessageSeen( chatId, messageId);
  }
}
