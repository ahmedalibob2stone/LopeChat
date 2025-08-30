
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodel/chat_group/archive_group_viewmodel.dart';
import '../../../viewmodel/chat_group/chat_group_viewmodel.dart';
import '../../../viewmodel/chat_group/delet_group_chat_messages_viewmodel.dart';
import '../usecase/provider.dart';

final chatGroupViewModelProvider =
StateNotifierProvider<ChatGroupViewModel, ChatGroupState>((ref) {
  final getChatGroups = ref.watch(getChatGroupsUseCaseProvider);
  final searchGroup = ref.watch(searchGroupUseCaseProvider);
  final openGroup = ref.watch(openGroupChatUseCaseProvider);
  final markSeen = ref.watch(markGroupMessagesAsSeenUseCaseProvider);

  return ChatGroupViewModel(
    getChatGroupsUseCase: getChatGroups,
    searchGroupUseCase: searchGroup,
    openGroupChatUseCase: openGroup,
    markGroupMessagesAsSeenUseCase: markSeen,
  );
});



final GroupArchivingViewModelProvider =
StateNotifierProvider<GroupArchivingViewModel, GroupArchivingState>((ref) {
  final archiveGroup = ref.watch(archiveGroupChatUseCaseProvider);
  final unarchiveGroup = ref.watch(unarchiveGroupChatUseCaseProvider);
  final getArchivedGroups = ref.watch(getArchivedGroupsUseCaseProvider);
  final getUnarchivedGroups = ref.watch(getUnarchivedGroupsUseCaseProvider);

  return GroupArchivingViewModel(
    archiveGroupChatUseCase: archiveGroup,
    getArchivedGroupsUseCase: getArchivedGroups,
    getUnarchivedGroupsUseCase: getUnarchivedGroups,
    unarchiveGroupChatUseCase: unarchiveGroup,
    auth: FirebaseAuth.instance,
  );
});
final deleteGroupChatMessagesViewModelProvider = StateNotifierProvider<DeleteGroupChatMessagesViewModel, DeleteGroupChatState>((ref) {
  final useCase = ref.read(deleteGroupChatMessagesUseCaseProvider);
  return DeleteGroupChatMessagesViewModel(deleteGroupChatUseCase: useCase);
});