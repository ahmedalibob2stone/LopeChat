import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/check internat/check_internat.dart';
import '../../domain/usecases/mark_status_as_seen_usecase.dart';
import '../../domain/usecases/delet_statuses_usecase.dart';

class StatusInteractionsState {
  final bool isLoading;
  final bool success;
  final bool isDeleted;
  final bool isSeen;
  final String? error;
  final String? message; // للـ Snackbar

  const StatusInteractionsState({
    this.isLoading = false,
    this.success = false,
    this.isDeleted = false,
    this.isSeen = false,
    this.error,
    this.message,
  });

  StatusInteractionsState copyWith({
    bool? isLoading,
    bool? success,
    bool? isDeleted,
    bool? isSeen,
    String? error,
    String? message,
  }) {
    return StatusInteractionsState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      isDeleted: isDeleted ?? this.isDeleted,
      isSeen: isSeen ?? this.isSeen,
      error: error,
      message: message,
    );
  }

  factory StatusInteractionsState.initial() => const StatusInteractionsState();
}

class StatusInteractionsViewModel extends StateNotifier<StatusInteractionsState> {
  final MarkStatusAsSeenUseCase markStatusAsSeenUseCase;
  final DeleteStatusUseCase deleteStatusUseCase;
  final CheckInternet checkInternet;

  StatusInteractionsViewModel({
    required this.markStatusAsSeenUseCase,
    required this.deleteStatusUseCase,
    required this.checkInternet,
  }) : super(StatusInteractionsState.initial());

  final Set<String> _shownNoViewerMessageFor = {};

  /// ✅ Mark status as seen
  Future<void> markAsSeen({
    required String statusId,
    required String imageUrl,
    required String currentUserUid,
  }) async {
    state = state.copyWith(isLoading: true, error: null, success: false);

    try {
      final hasNet = await checkInternet.IsConnected();
      if (!hasNet) {
        state = state.copyWith(
          isLoading: false,
          error: "No internet connection",
          message: "No internet connection",
        );
        return;
      }

      await markStatusAsSeenUseCase(
        statusId: statusId,
        imageUrl: imageUrl,
        currentUserUid: currentUserUid,
      );

      state = state.copyWith(
        isLoading: false,
        success: true,
        isSeen: true,
        message: "Marked as seen successfully",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        success: false,
      );
    }
  }

  /// Delete status
  Future<bool> deleteStatus({
    required String statusId,
    required int index,
    required List<String> photoUrls,
  }) async {
    state = state.copyWith(isLoading: true, error: null, success: false);

    final currentPhotoUrls = List<String>.from(photoUrls);

    try {
      final hasNet = await checkInternet.IsConnected();
      if (!hasNet) {
        state = state.copyWith(
          isLoading: false,
          error: "No internet connection",
          message: "Please check your network connection",
        );
        return false;
      }

      final success = await deleteStatusUseCase(
        statusId: statusId,
        index: index,
        photoUrls: currentPhotoUrls,
      );

      if (success) {
        state = state.copyWith(
          isLoading: false,
          success: true,
          isDeleted: true,
          message: "Status deleted successfully",
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Deletion failed",
          message: "Failed to delete the status",
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        message: "An error occurred while deleting",
      );
      return false;
    }
  }

  /// Reset state
  void reset() {
    state = StatusInteractionsState.initial();
  }
}
