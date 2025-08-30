
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../group/domain/entities/group_entity.dart';
import '../../../domain/usecase/chat_group_usecase/archive_group_chat_usecase.dart';
import '../../../domain/usecase/chat_group_usecase/get_archived_groups_usecase.dart';
import '../../../domain/usecase/chat_group_usecase/get_unarchived_groups_usecase.dart';
import '../../../domain/usecase/chat_group_usecase/unarchive_group_chat_usecase.dart';

class GroupArchivingState {
  final bool isLoading;
  final List<GroupEntity> groups;
  final List<GroupEntity> archivedGroups;
  final String? error;

  GroupArchivingState({
    this.isLoading = false,
    this.groups = const [],
    this.archivedGroups = const [],
    this.error,
  });

  GroupArchivingState copyWith({
    bool? isLoading,
    List<GroupEntity>? groups,
    List<GroupEntity>? archivedGroups,
    String? error,
  }) {
    return GroupArchivingState(
      isLoading: isLoading ?? this.isLoading,
      groups: groups ?? this.groups,
      archivedGroups: archivedGroups ?? this.archivedGroups,
      error: error,
    );
  }
}

class GroupArchivingViewModel extends StateNotifier<GroupArchivingState> {
  final ArchiveGroupChatUseCase archiveGroupChatUseCase;
  final GetArchivedGroupsUseCase getArchivedGroupsUseCase;
  final GetUnarchivedGroupsUseCase getUnarchivedGroupsUseCase;
  final UnarchiveGroupChatUseCase unarchiveGroupChatUseCase;
  final FirebaseAuth auth;
  StreamSubscription<List<GroupEntity>>? _groupSubscription;
  StreamSubscription<List<GroupEntity>>? _archivedSubscription;

  GroupArchivingViewModel({
    required this.archiveGroupChatUseCase,
    required this.getArchivedGroupsUseCase,
    required this.getUnarchivedGroupsUseCase,
    required this.unarchiveGroupChatUseCase,
     required this.auth,
  }) : super(GroupArchivingState());
  String get userId => auth.currentUser?.uid ?? '';

  Future<void> loadUnarchivedGroup() async {
    if (userId.isEmpty) return;
    state = state.copyWith(isLoading: true);
    _groupSubscription?.cancel();
    _groupSubscription = getUnarchivedGroupsUseCase(userId).listen(
          (groups) {
        state = state.copyWith(isLoading: false, groups: groups);
      },
      onError: (error) {
        state = state.copyWith(isLoading: false, error: error.toString());
      },
    );
  }
  Future<void> loadArchivedChats() async {
    if (userId.isEmpty) return;
    _archivedSubscription?.cancel();
    _archivedSubscription = getArchivedGroupsUseCase(userId).listen(
          (groups) {
        state = state.copyWith(archivedGroups: groups);  // ملاحظة هنا (راجع النقطة 3)
      },
      onError: (error) {
        state = state.copyWith(error: error.toString());
      },
    );
  }
  Future<void> archiveGroup(String groupId) async {
    if (userId.isEmpty) return;
    await archiveGroupChatUseCase(groupId: groupId, userId: userId);
  }
  Future<void> unarchiveGroup(String groupId) async {
    if (userId.isEmpty) return;
    await unarchiveGroupChatUseCase(groupId: groupId, userId: userId);
  }

  @override
  void dispose() {
    _groupSubscription?.cancel();
    _archivedSubscription?.cancel();
    super.dispose();
  }
}
