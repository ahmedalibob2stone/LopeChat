import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecase/chat_massage_usecase/mark_messages_as_seen_usecase.dart';
import '../../../domain/usecase/chat_massage_usecase/set_chat_message_seen_usecase.dart';

class ChatSeenViewModel extends StateNotifier<void> {
  final MarkMessagesAsSeenUseCase  markMessagesAsSeenUseCase;

  ChatSeenViewModel(this.markMessagesAsSeenUseCase) : super(null);

  Future<void> markMessageAsSeen(String chatId, String messageId) async {
    await markMessagesAsSeenUseCase.execute(chatId, messageId);
  }
}
