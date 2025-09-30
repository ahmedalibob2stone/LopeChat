import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/mark_status_as_seen_usecase.dart';

class StatusViewModel extends StateNotifier<StatusViewModelState> {
  final MarkStatusAsSeenUseCase markStatusAsSeenUseCase;

  StatusViewModel({required this.markStatusAsSeenUseCase})
      : super(StatusViewModelState());

  Future<void> markAsSeen({
    required String statusId,
    required String imageUrl,
    required String currentUserUid,
  }) async {
    state = state.copyWith(isLoading: true, success: false, error: null);

    try {
      await markStatusAsSeenUseCase(
        statusId: statusId,
        imageUrl: imageUrl,
        currentUserUid: currentUserUid,
      );

      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, success: false, error: e.toString());
    }
  }

  /// إعادة ضبط الحالة
  void reset() {
    state = StatusViewModelState();
  }
}

class StatusViewModelState {
  final bool isLoading;
  final bool success;
  final String? error;

  StatusViewModelState({
    this.isLoading = false,
    this.success = false,
    this.error,
  });

  StatusViewModelState copyWith({
    bool? isLoading,
    bool? success,
    String? error,
  }) {
    return StatusViewModelState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      error: error,
    );
  }
}
