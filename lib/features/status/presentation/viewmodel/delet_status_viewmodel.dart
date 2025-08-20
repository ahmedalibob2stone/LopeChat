import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/delet_statuses_usecase.dart';


class DeleteStatusState {
  final bool isLoading;
  final bool success;
  final String? error;

  DeleteStatusState({
    this.isLoading = false,
    this.success = false,
    this.error,
  });

  DeleteStatusState copyWith({
    bool? isLoading,
    bool? success,
    String? error,
  }) {
    return DeleteStatusState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      error: error,
    );
  }

  factory DeleteStatusState.initial() => DeleteStatusState();
}


class DeleteStatusViewModel extends StateNotifier<DeleteStatusState> {
  final DeleteStatusUseCase deleteUseCase;

  DeleteStatusViewModel(this.deleteUseCase) : super(DeleteStatusState.initial());

  Future<bool> deleteStatus(int index, List<String> photoUrls) async {
    state = state.copyWith(isLoading: true, error: null, success: false);
    try {
      final success = await deleteUseCase(index: index, photoUrls: photoUrls);
      if (success) {
        state = state.copyWith(isLoading: false, success: true);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'فشل في حذف الحالة');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void reset() {
    state = DeleteStatusState.initial();
  }
}
