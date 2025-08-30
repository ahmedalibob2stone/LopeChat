import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodel/chat_group/group_list_viewModel.dart';
import '../../../viewmodel/chat_massage/chat_display_viewmodel.dart';
import '../../../viewmodel/chat_massage/chat_message_seen.dart';
import '../../../viewmodel/chat_massage/delete_message_viewmodel.dart';
import '../../../viewmodel/chat_massage/send_message_viewmodel.dart';
import '../../../viewmodel/chat_massage/chat_massage_viewmodel.dart';
import '../../chat_group/usecase/provider.dart';
import '../usecase/provider.dart';

final messageViewModelProvider =
StateNotifierProvider<MessageViewModel, MessageState>((ref) {
  return MessageViewModel(
    sendTextMessageUseCase: ref.watch(sendTextMessageUseCaseProvider),
    sendFileMessageUseCase: ref.watch(sendFileMessageUseCaseProvider),
    sendGifMessageUseCase: ref.watch(sendGIFMessageUseCaseProvider),
    deleteMessageUseCase: ref.watch(deleteMessageUseCaseProvider),
    setChatMessageSeenUseCase: ref.watch(setChatMessageSeenUseCaseProvider),
    markMessageAsSeenUseCase: ref.watch(markMessagesAsSeenUseCaseProvider),
  );
});
final sendMessageViewModelProvider =
StateNotifierProvider<SendMessageViewModel, SendMessageState>((ref) {
  return SendMessageViewModel(
    sendTextMessageUseCase: ref.read(sendTextMessageUseCaseProvider),
    sendFileMessageUseCase: ref.read(sendFileMessageUseCaseProvider),
    sendLinkMessageUseCase: ref.read(sendLinkMessageUseCaseProvider),

    sendGIFMessageUseCase: ref.read(sendGIFMessageUseCaseProvider),
  );
});
final chatDisplayViewModelProvider = StateNotifierProvider<ChatDisplayViewModel, void>((ref) {
  final useCase = ref.watch(setChatMessageSeenUseCaseProvider);
  return ChatDisplayViewModel(useCase);
});
final chatSeenViewModelProvider =
StateNotifierProvider<ChatSeenViewModel, void>((ref) {
  final useCase = ref.watch(markMessagesAsSeenUseCaseProvider);
  return ChatSeenViewModel(useCase);
});
final deleteMessageViewModelProvider =
StateNotifierProvider<DeleteMessageViewModel, void>((ref) {
  final usecase = ref.watch(deleteMessageUseCaseProvider);
  return DeleteMessageViewModel(usecase);
});
final groupListViewModelProvider = StateNotifierProvider<GroupListViewModel, GroupListState>((ref) {
  final useCase = ref.watch(getChatGroupsUseCaseProvider); // تأكد من أنك أنشأت مزود للـ useCase
  return GroupListViewModel(useCase);
});
