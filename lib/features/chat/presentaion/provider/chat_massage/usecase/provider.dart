import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecase/chat_massage_usecase/delete_message_usecase.dart';
import '../../../../domain/usecase/chat_massage_usecase/get_group_chat_stream_usecase.dart';
import '../../../../domain/usecase/chat_massage_usecase/get_stream_messages_usecase.dart';
import '../../../../domain/usecase/chat_massage_usecase/mark_messages_as_seen_usecase.dart';
import '../../../../domain/usecase/chat_massage_usecase/send_file_message_usecase.dart';
import '../../../../domain/usecase/chat_massage_usecase/send_gif_message_usecase.dart';
import '../../../../domain/usecase/chat_massage_usecase/send_link_message_usecase.dart';
import '../../../../domain/usecase/chat_massage_usecase/send_text_message_usecase.dart';
import '../../../../domain/usecase/chat_massage_usecase/set_chat_message_seen_usecase.dart';
import '../data/provider.dart';

//SendTextMessageUseCase
final sendTextMessageUseCaseProvider = Provider<SendTextMessageUseCase>((ref) {
  final repo = ref.watch(chatMessageRepositoryProvider);
  return SendTextMessageUseCase(repo);
});



//SendFileMessageUseCase
final sendFileMessageUseCaseProvider = Provider<SendFileMessageUseCase>((ref) {
  final repo = ref.watch(chatMessageRepositoryProvider);
  return SendFileMessageUseCase(repo);
});



//SendGIFMessageUseCase
final sendGIFMessageUseCaseProvider = Provider<SendGifMessageUseCase>((ref) {
  final repo = ref.watch(chatMessageRepositoryProvider);
  return SendGifMessageUseCase(repo);
});

final sendLinkMessageUseCaseProvider = Provider<SendLinkMessageUseCase>((ref) {
  final repo = ref.watch(chatMessageRepositoryProvider);
  return SendLinkMessageUseCase(repo);
});

//GetStreamMessagesUseCase
final getStreamMessagesUseCaseProvider = Provider<GetStreamMessagesUseCase>((ref) {
  final repo = ref.watch(chatMessageRepositoryProvider);
  return GetStreamMessagesUseCase(repo);
});



//GetGroupChatStreamUseCase
final getGroupChatStreamUseCaseProvider = Provider<GetGroupChatStreamUseCase>((ref) {
  final repo = ref.watch(chatMessageRepositoryProvider);
  return GetGroupChatStreamUseCase(repo);
});



//DeleteMessageUseCase
final deleteMessageUseCaseProvider = Provider<DeleteMessageUseCase>((ref) {
  final repo = ref.watch(chatMessageRepositoryProvider);
  return DeleteMessageUseCase(repo);
});



//DeleteChatMessagesUseCase


//SetChatMessageSeenUseCase
final setChatMessageSeenUseCaseProvider = Provider<SetChatMessageSeenUseCase>((ref) {
  final repo = ref.watch(chatMessageRepositoryProvider);
  return SetChatMessageSeenUseCase(repo);
});



//MarkMessagesAsSeenUseCase
final markMessagesAsSeenUseCaseProvider = Provider<MarkMessagesAsSeenUseCase>((ref) {
  final repo = ref.watch(chatMessageRepositoryProvider);
  return MarkMessagesAsSeenUseCase(repo);
});
