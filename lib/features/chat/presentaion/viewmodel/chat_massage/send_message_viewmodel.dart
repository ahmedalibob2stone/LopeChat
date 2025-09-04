
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/Provider/Message_reply.dart';
import '../../../../../common/enums/enum_massage.dart';
import '../../../../user/data/user_model/user_model.dart';
import '../../../domain/usecase/chat_massage_usecase/send_file_message_usecase.dart';
import '../../../domain/usecase/chat_massage_usecase/send_gif_message_usecase.dart';
import '../../../domain/usecase/chat_massage_usecase/send_link_message_usecase.dart';
import '../../../domain/usecase/chat_massage_usecase/send_text_message_usecase.dart';

class SendMessageState {
  final bool isSending;
  final bool isSuccess;
  final String? error;

  const SendMessageState({
    this.isSending = false,
    this.isSuccess = false,
    this.error,
  });

  SendMessageState copyWith({
    bool? isSending,
    bool? isSuccess,
    String? error,
  }) {
    return SendMessageState(
      isSending: isSending ?? this.isSending,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }
}
class SendMessageViewModel extends StateNotifier<SendMessageState> {
  final SendTextMessageUseCase sendTextMessageUseCase;
  final SendFileMessageUseCase sendFileMessageUseCase;
  final SendGifMessageUseCase sendGIFMessageUseCase;
  final SendLinkMessageUseCase sendLinkMessageUseCase;

  SendMessageViewModel({
    required this.sendTextMessageUseCase,
    required this.sendFileMessageUseCase,
    required this.sendGIFMessageUseCase,
    required this.sendLinkMessageUseCase,
  }) : super(const SendMessageState());

  Future<void> sendTextMessage({
    required String text,
    required String reciveUserId,
    required UserModel sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,

  }) async {
    try {
      state = state.copyWith(isSending: true, error: null, isSuccess: false);
      await sendTextMessageUseCase.execute(
        text: text,
        chatId: reciveUserId,
        sendUser: sendUser.toEntity(),
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
      state = state.copyWith(isSending: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSending: false, error: e.toString(), isSuccess: false);
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
      state = state.copyWith(isSending: true, error: null, isSuccess: false);
      await sendFileMessageUseCase.execute(
        file: file,
        chatId: chatId,
        senderUserDate: senderUserDate.toEntity(),
        massageEnum: massageEnum,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
      state = state.copyWith(isSending: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSending: false, error: e.toString(), isSuccess: false);
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
      state = state.copyWith(isSending: true, error: null, isSuccess: false);
      await sendGIFMessageUseCase.execute(
        gif: gif,
        chatId: chatId,
        sendUser: sendUser.toEntity(),
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
      state = state.copyWith(isSending: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSending: false, error: e.toString(), isSuccess: false);
    }
  }
  Future<void> sendLinkMessage({
    required String link,
    required String reciveUserId,
    required UserModel sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,

  }) async {
    try {
      state = state.copyWith(isSending: true, error: null, isSuccess: false);
      await sendLinkMessageUseCase.call(
          link: link,
        chatId: reciveUserId,
        sendUser: sendUser.toEntity(),
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
      state = state.copyWith(isSending: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSending: false, error: e.toString(), isSuccess: false);
    }
  }
}
