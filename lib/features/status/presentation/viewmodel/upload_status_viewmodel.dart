import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../user/presentation/provider/stream_provider/get_user_data_stream_provider.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../../domain/usecases/upload_status_usecase.dart';

class UploadStatusState {
  final bool isLoading;
  final bool success;
  final String? error;

  const UploadStatusState({
    this.isLoading = false,
    this.success = false,
    this.error,
  });

  UploadStatusState copyWith({
    bool? isLoading,
    bool? success,
    String? error,
  }) {
    return UploadStatusState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      error: error,
    );
  }

  factory UploadStatusState.initial() => const UploadStatusState();
}

class UploadStatusViewModel extends StateNotifier<UploadStatusState> {
  final UploadStatusUseCase useCase;
  final Ref ref;

  UploadStatusViewModel(this.useCase, this.ref)
      : super(UploadStatusState.initial());

  Future<void> uploadStatus({
    required File file,
    required String message,
  }) async {
    final userAsync = ref.read(currentUserStreamProvider);

    userAsync.whenData((user) async {
      if (user == null) {
        state = const UploadStatusState(error: 'User not logged in');
        return;
      }

      try {
        state = const UploadStatusState(isLoading: true);

        await useCase(
          username: user.name,
          profilePic: user.profile,
          phoneNumber: user.phoneNumber,
          statusImage: file,
          statusMessage: message,
        );

        state = const UploadStatusState(success: true);
      } catch (e) {
        state = UploadStatusState(error: e.toString());
      }
    });
  }

  void resetState() {
    state = UploadStatusState.initial();
  }
}
