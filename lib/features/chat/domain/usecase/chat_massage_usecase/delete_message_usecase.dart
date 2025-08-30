import 'package:flutter/material.dart';
import '../../repository/chat_message_repository.dart';

class DeleteMessageUseCase {
  final IChatMessageRepository repository;

  DeleteMessageUseCase(this.repository);

  Future<void> execute({
    required String chatId,
    required String messageId,
  }) async {
    await repository.deleteMessage(
      chatId: chatId,
      messageId: messageId,
    );
  }
}
