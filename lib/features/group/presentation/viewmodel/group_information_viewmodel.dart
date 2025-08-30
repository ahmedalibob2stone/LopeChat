import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/group_entity.dart';
import '../../domain/usecase/get_group_Info_usecase.dart';

class GroupInformationState {
  final bool isLoading;
  final String? errorMessage;
  final GroupEntity? group;

  GroupInformationState({
    this.isLoading = false,
    this.errorMessage,
    this.group,
  });

  GroupInformationState copyWith({
    bool? isLoading,
    String? errorMessage,
    GroupEntity? group,
  }) {
    return GroupInformationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      group: group ?? this.group,
    );
  }
}

class GroupInformationViewModel extends StateNotifier<GroupInformationState> {
  final GetGroupInfoUseCase getGroupInfoUseCase;

  GroupInformationViewModel({required this.getGroupInfoUseCase}) : super(GroupInformationState());

  Future<void> loadGroupInfo(String groupId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final group = await getGroupInfoUseCase.execute(groupId);
      state = state.copyWith(isLoading: false, group: group);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
