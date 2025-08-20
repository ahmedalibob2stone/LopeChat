import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../../domain/usecase/update_group_info_usecase.dart';

class UpdateGroupInfoState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  UpdateGroupInfoState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  UpdateGroupInfoState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return UpdateGroupInfoState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class UpdateGroupInfoViewModel extends StateNotifier<UpdateGroupInfoState> {
  final UpdateGroupInfoUseCase updateGroupInfoUseCase;

  UpdateGroupInfoViewModel({required this.updateGroupInfoUseCase}) : super(UpdateGroupInfoState());

  Future<void> updateGroupInfo({
    required String groupId,
    String? newName,
    File? newProfileImage,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      await updateGroupInfoUseCase.execute(
        groupId: groupId,
        newName: newName,
        newProfileImage: newProfileImage,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
