import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entites/callentites.dart';
import '../../domain/usecase/create_call_usecase.dart';
import '../../domain/usecase/mke_group_call_usecase.dart';

enum CallCreateStatus { idle, loading, success, error }

class CallCreateState {
  final CallCreateStatus status;
  final bool isVideo;
  final String? errorMessage;

  const CallCreateState({
    this.status = CallCreateStatus.idle,
    this.isVideo = false,
    this.errorMessage,
  });

  CallCreateState copyWith({
    CallCreateStatus? status,
    bool? isVideo,
    String? errorMessage,
  }) {
    return CallCreateState(
      status: status ?? this.status,
      isVideo: isVideo ?? this.isVideo,
      errorMessage: errorMessage,
    );
  }
}

class CreateCallViewModel extends StateNotifier<CallCreateState> {
  final CreateCallUseCase createCallUseCase;
  final MakeGroupCallUseCase makeGroupCallUseCase;
  final Ref ref;

  CreateCallViewModel({
    required this.createCallUseCase,
    required this.makeGroupCallUseCase,
    required this.ref,
  }) : super(const CallCreateState());

  Future<void> createCall({
    required CallEntites senderCall,
    required CallEntites receiverCall,
    required bool isGroupChat,
    required bool isVideo, required BuildContext context,
  }) async {
    state = state.copyWith(status: CallCreateStatus.loading, isVideo: isVideo);

    try {
      if (isGroupChat) {
        await makeGroupCallUseCase.call(
          senderCall.copyWith(isVideo: isVideo),
          receiverCall.copyWith(isVideo: isVideo),
        );
      } else {
        await createCallUseCase.call(
          senderCall.copyWith(isVideo: isVideo),
          receiverCall.copyWith(isVideo: isVideo),
        );
      }

      state = state.copyWith(status: CallCreateStatus.success);
    } catch (e, st) {
      state = state.copyWith(
        status: CallCreateStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const CallCreateState();
  }
}
