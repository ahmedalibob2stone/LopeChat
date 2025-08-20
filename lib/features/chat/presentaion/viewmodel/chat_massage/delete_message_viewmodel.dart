import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecase/chat_massage_usecase/delete_message_usecase.dart';

class DeleteMessageViewModel extends StateNotifier<void> {
  final DeleteMessageUseCase deleteMessageUseCase;

  DeleteMessageViewModel(this.deleteMessageUseCase) : super(null);

  Future<void> deleteMessage({
    required BuildContext context,
    required String chatId,
    required String messageId,
  }) async {
    try {
      await deleteMessageUseCase.execute(
        chatId: chatId,
        messageId: messageId,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء حذف الرسالة: $e')),
      );
    }
  }
}
