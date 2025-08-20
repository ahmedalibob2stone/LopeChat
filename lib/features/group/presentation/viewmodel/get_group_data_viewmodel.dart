
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/group_entity.dart';
import '../../domain/usecase/get_group_data_usecase.dart';


class GroupInfoState {
  final bool isLoading;
  final GroupEntity? groupData;
  final String? error;

  GroupInfoState({
    this.isLoading = false,
    this.groupData,
    this.error,
  });

  GroupInfoState copyWith({
    bool? isLoading,
    GroupEntity? groupData,
    String? error,
  }) {
    return GroupInfoState(
      isLoading: isLoading ?? this.isLoading,
      groupData: groupData ?? this.groupData,
      error: error,
    );
  }
}

class GroupInfoViewModel extends StateNotifier<GroupInfoState> {
  final GetGroupDataUseCase getGroupDataUseCase;
  StreamSubscription<GroupEntity>? _subscription;

  GroupInfoViewModel({required this.getGroupDataUseCase}) : super(GroupInfoState());

  void getGroupData(String groupId) {
    // إلغاء أي اشتراك سابق
    _subscription?.cancel();

    state = state.copyWith(isLoading: true, error: null);

    _subscription = getGroupDataUseCase.execute(groupId).listen(
          (group) {
        state = state.copyWith(groupData: group, isLoading: false);
      },
      onError: (e) {
        state = state.copyWith(error: e.toString(), isLoading: false);
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}