import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/Provider/Message_reply.dart';
import '../../../../../common/enums/enum_massage.dart';
import '../../../../user/data/user_model/user_model.dart';
import '../../../domain/usecase/chat_massage_usecase/delete_message_usecase.dart';
import '../../../domain/usecase/chat_massage_usecase/mark_messages_as_seen_usecase.dart';
import '../../../domain/usecase/chat_massage_usecase/send_file_message_usecase.dart';
import '../../../domain/usecase/chat_massage_usecase/send_gif_message_usecase.dart';
import '../../../domain/usecase/chat_massage_usecase/send_text_message_usecase.dart';
import '../../../domain/usecase/chat_massage_usecase/set_chat_message_seen_usecase.dart';

class MessageState {
  final bool isSending;
  final bool isDeleting;
  final String? error;
  final bool isUpdating;
  MessageState({
    this.isSending = false,
    this.isDeleting = false,
    this.error,
    this.isUpdating= false

  });

  MessageState copyWith({
    bool? isSending,
    bool? isDeleting,
    String? error,
    bool? isUpdating,

  }) {
    return MessageState(
        isSending: isSending ?? this.isSending,
        isDeleting: isDeleting ?? this.isDeleting,
        error: error,
        isUpdating: isUpdating ?? this.isUpdating

    );
  }
}

class MessageViewModel extends StateNotifier<MessageState> {
  final SendTextMessageUseCase sendTextMessageUseCase;
  final SendFileMessageUseCase sendFileMessageUseCase;
  final SendGifMessageUseCase sendGifMessageUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
//  final DeleteChatMessagesUseCase deleteChatMessageUseCase;
  final SetChatMessageSeenUseCase setChatMessageSeenUseCase;
  final MarkMessagesAsSeenUseCase markMessageAsSeenUseCase;

  MessageViewModel({
    required this.sendTextMessageUseCase,
    required this.sendFileMessageUseCase,
    required this.sendGifMessageUseCase,
    required this.deleteMessageUseCase,
  //  required this.deleteChatMessageUseCase,
    required this.setChatMessageSeenUseCase,
    required this.markMessageAsSeenUseCase,
  }) : super(MessageState());

  Future<void> sendTextMessage({
    required String text,
    required String chatId,
    required UserModel sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      state = state.copyWith(isSending: true);
      await sendTextMessageUseCase.execute(
        text: text,
        chatId: chatId,
        sendUser: sendUser,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
      state = state.copyWith(isSending: false, error: null);
    } catch (e) {
      state = state.copyWith(isSending: false, error: e.toString());
    }
  }

  Future<void> sendFileMessage({
    required File file,
    required String chatId,
    required UserModel senderUserDate,
    required EnumData massageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      state = state.copyWith(isSending: true);
      await sendFileMessageUseCase.execute(
        file: file,
        chatId: chatId,
        senderUserDate: senderUserDate,
        massageEnum: massageEnum,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
      state = state.copyWith(isSending: false, error: null);
    } catch (e) {
      state = state.copyWith(isSending: false, error: e.toString());
    }
  }

  Future<void> sendGIFMessage({
    required String gif,
    required String chatId,
    required UserModel sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      state = state.copyWith(isSending: true);
      await sendGifMessageUseCase.execute(
        gif: gif,
        chatId: chatId,
        sendUser: sendUser,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
      state = state.copyWith(isSending: false, error: null);
    } catch (e) {
      state = state.copyWith(isSending: false, error: e.toString());
    }
  }

  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      state = state.copyWith(isDeleting: true);
      await deleteMessageUseCase.execute(
        chatId: chatId,
        messageId: messageId,
      );
      state = state.copyWith(isDeleting: false);
    } catch (e) {
      state = state.copyWith(isDeleting: false, error: e.toString());
    }
  }

  Future<void> markMessagesAsSeen(String chatId, String contactId) async {
    try {
      state = state.copyWith(isUpdating: true);
      await markMessageAsSeenUseCase.execute(chatId, contactId);
      state = state.copyWith(isUpdating: false);
    } catch (e) {
      state = state.copyWith(isUpdating: false, error: e.toString());
    }
  }

  Future<void> setChatMassageSeen(
      String chatId,
      String messageId,
      ) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      await setChatMessageSeenUseCase.execute(
        chatId,
        messageId,
      );
      state = state.copyWith(isUpdating: false);
    } catch (e) {
      state = state.copyWith(isUpdating: false, error: e.toString());
    }
  }
}
