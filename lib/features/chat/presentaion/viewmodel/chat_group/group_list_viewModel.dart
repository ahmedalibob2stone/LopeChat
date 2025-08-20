import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../group/domain/entities/group_entity.dart';
import '../../../domain/usecase/chat_group_usecase/get_chat_group_usecase.dart';


class GroupListState {
  final bool isLoading;
  final bool isSuccess;
  final List<GroupEntity> groups;
  final String? error;

  GroupListState({
    this.isLoading = false,
    this.isSuccess = false,
    this.groups = const [],
    this.error,
  });

  GroupListState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<GroupEntity>? groups,
    String? error,
  }) {
    return GroupListState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      groups: groups ?? this.groups,
      error: error,
    );
  }

  factory GroupListState.initial() => GroupListState();
}


class GroupListViewModel extends StateNotifier<GroupListState> {
  final GetChatGroupsUseCase getChatGroupsUseCase;
  StreamSubscription? _subscription;

  GroupListViewModel(this.getChatGroupsUseCase) : super(GroupListState.initial()) {
    getChatGroups();
  }

  void getChatGroups() {
    state = state.copyWith(isLoading: true, error: null);
    _subscription?.cancel();

    _subscription = getChatGroupsUseCase.call().listen(
          (groups) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          groups: groups,
        );
      },
      onError: (error) {
        state = state.copyWith(
          isLoading: false,
          error: error.toString(),
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
