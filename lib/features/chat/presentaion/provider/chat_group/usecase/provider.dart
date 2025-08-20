

import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../domain/usecase/chat_group_usecase/archive_group_chat_usecase.dart';
import '../../../../domain/usecase/chat_group_usecase/delete_group_chat_messages_usecase.dart';
import '../../../../domain/usecase/chat_group_usecase/get_archived_groups_usecase.dart';
import '../../../../domain/usecase/chat_group_usecase/get_chat_group_usecase.dart';
import '../../../../domain/usecase/chat_group_usecase/get_unarchived_groups_usecase.dart';
import '../../../../domain/usecase/chat_group_usecase/mark_group_messages_asSeen_usecase.dart';
import '../../../../domain/usecase/chat_group_usecase/open_group_chat_usecase.dart';
import '../../../../domain/usecase/chat_group_usecase/search_group_usecase.dart';
import '../../../../domain/usecase/chat_group_usecase/unarchive_group_chat_usecase.dart';
import '../datasource/provider.dart';

//GetChatGroupsUseCase

final getChatGroupsUseCaseProvider = Provider<GetChatGroupsUseCase>((ref) {
  final repository = ref.watch(chatGroupRepositoryProvider);
  return GetChatGroupsUseCase(repository);
});

//SearchGroupUseCase
final searchGroupUseCaseProvider = Provider<SearchGroupUseCase>((ref) {
  final repository = ref.watch(chatGroupRepositoryProvider);
  return SearchGroupUseCase(repository);
});



//OpenGroupChatUseCase

final openGroupChatUseCaseProvider = Provider<OpenGroupChatUseCase>((ref) {
  final repository = ref.watch(chatGroupRepositoryProvider);
  return OpenGroupChatUseCase(repository);
});

//GetGroupDataUseCase


//GetGroupDataUseCase

final markGroupMessagesAsSeenUseCaseProvider = Provider<MarkGroupMessagesAsSeenUseCase>((ref) {
  final repository = ref.watch(chatGroupRepositoryProvider);
  return MarkGroupMessagesAsSeenUseCase(repository);
});

final archiveGroupChatUseCaseProvider = Provider<ArchiveGroupChatUseCase>((ref) {
  final repo = ref.read(chatGroupRepositoryProvider);
  return ArchiveGroupChatUseCase(repo);
});

final unarchiveGroupChatUseCaseProvider = Provider<UnarchiveGroupChatUseCase>((ref) {
  final repo = ref.read(chatGroupRepositoryProvider);
  return UnarchiveGroupChatUseCase(repo);
});
final getArchivedGroupsUseCaseProvider = Provider<GetArchivedGroupsUseCase>((ref) {
  final repo = ref.read(chatGroupRepositoryProvider);
  return GetArchivedGroupsUseCase(repo);
});
final getUnarchivedGroupsUseCaseProvider = Provider<GetUnarchivedGroupsUseCase>((ref) {
  final repo = ref.read(chatGroupRepositoryProvider);
  return GetUnarchivedGroupsUseCase(repo);
});
final deleteGroupChatMessagesUseCaseProvider = Provider<DeleteGroupChatMessagesUseCase>((ref) {
  final repository = ref.read(chatGroupRepositoryProvider);
  return DeleteGroupChatMessagesUseCase(repository);
});