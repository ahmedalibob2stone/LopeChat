import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/chat_massage_usecase/set_chat_message_seen_usecase.dart';

class ChatDisplayViewModel extends StateNotifier<void> {
  final SetChatMessageSeenUseCase setChatMassageSeenUseCase;

  ChatDisplayViewModel(this.setChatMassageSeenUseCase) : super(null);

  Future<void> markMessageAsSeen( String chatId, String messageId) {
    return setChatMassageSeenUseCase.execute( chatId, messageId);
  }
}
