
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../group/domain/entities/group_entity.dart';
import '../../../domain/usecase/chat_group_usecase/get_chat_group_usecase.dart';
import '../../../domain/usecase/chat_group_usecase/mark_group_messages_asSeen_usecase.dart';
import '../../../domain/usecase/chat_group_usecase/open_group_chat_usecase.dart';
import '../../../domain/usecase/chat_group_usecase/search_group_usecase.dart';
class ChatGroupState {
  final bool isLoading;
  final bool isSuccess;
  final List<GroupEntity> groups;
  final String? error;
  final bool isDeleting;
  final String? deleteError;
  final bool isUpdatingGroupChat;
  final bool isUpdatingGroupData;
  final bool isMarkingGroupMessagesAsSeen;
  final String? markSeenError;

  ChatGroupState({
    this.isLoading = false,
    this.isSuccess = false,
    this.groups = const [],
    this.error,
    this.isDeleting = false,
    this.deleteError,
    this.isUpdatingGroupChat = false,
    this.isUpdatingGroupData=false,
    this.isMarkingGroupMessagesAsSeen = false,
    this.markSeenError,
  });

  ChatGroupState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<GroupEntity>? groups,
    String? error,
    bool? isDeleting,
    String? deleteError,
    bool? isUpdatingGroupChat,
    bool? isUpdatingGroupChatData,
    bool? isMarkingGroupMessagesAsSeen,
    String? markSeenError,
  }) {
    return ChatGroupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      groups: groups ?? this.groups,
      error: error,
      isDeleting: isDeleting ?? this.isDeleting,
      deleteError: deleteError,
      isUpdatingGroupChat: isUpdatingGroupChat ?? this.isUpdatingGroupChat,
      isMarkingGroupMessagesAsSeen:
      isMarkingGroupMessagesAsSeen ?? this.isMarkingGroupMessagesAsSeen,
      markSeenError: markSeenError,
      isUpdatingGroupData :
      isUpdatingGroupData ??this.isUpdatingGroupData,
    );
  }
}


class ChatGroupViewModel extends StateNotifier<ChatGroupState> {
  final GetChatGroupsUseCase getChatGroupsUseCase;
  final SearchGroupUseCase searchGroupUseCase;
  final OpenGroupChatUseCase openGroupChatUseCase;
  final MarkGroupMessagesAsSeenUseCase markGroupMessagesAsSeenUseCase;

  StreamSubscription<List<GroupEntity>>? _subscription;

  ChatGroupViewModel({
    required this.getChatGroupsUseCase,
    required this.searchGroupUseCase,
    required this.openGroupChatUseCase,
    required this.markGroupMessagesAsSeenUseCase,
  }) : super(ChatGroupState());

  void getChatGroups() {
    state = state.copyWith(isLoading: true, error: null);
    _subscription?.cancel();

    _subscription = getChatGroupsUseCase.call().listen(
          (groups) {
        state = state.copyWith(isLoading: false, isSuccess: true, groups: groups);
      },
      onError: (error) {
        state = state.copyWith(isLoading: false, error: error.toString());
      },
    );
  }

  void searchGroups(String query) {
    state = state.copyWith(isLoading: true, error: null);
    _subscription?.cancel();

    _subscription = searchGroupUseCase.execute(searchName: query).listen(
          (groups) {
        state = state.copyWith(isLoading: false, isSuccess: true, groups: groups);
      },
      onError: (error) {
        state = state.copyWith(isLoading: false, error: error.toString());
      },
    );
  }


  Future<void> markGroupMessagesAsSeen({
    required String groupId,
    required String uid,
  }) async {
    state = state.copyWith(isMarkingGroupMessagesAsSeen: true, markSeenError: null);
    try {
      await markGroupMessagesAsSeenUseCase.execute(groupId: groupId, uid: uid);
    } catch (e) {
      state = state.copyWith(markSeenError: e.toString());
    } finally {
      state = state.copyWith(isMarkingGroupMessagesAsSeen: false);
    }
  }

  Future<void> openGroupChat(String groupId) async {
    state = state.copyWith(isUpdatingGroupChat: true);
    try {
      await openGroupChatUseCase.execute(groupId);
    } finally {
      state = state.copyWith(isUpdatingGroupChat: false);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
