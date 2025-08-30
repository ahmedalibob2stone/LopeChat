import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecase/call_stream_usecase.dart';
class CallPickupState {
  final DocumentSnapshot? snapshot;
  final bool isLoading;
  final String? error;

  CallPickupState({
    this.snapshot,
    this.isLoading = false,
    this.error,
  });

  CallPickupState copyWith({
    DocumentSnapshot? snapshot,
    bool? isLoading,
    String? error,
  }) {
    return CallPickupState(
      snapshot: snapshot ?? this.snapshot,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}


class CallPickupViewModel extends StateNotifier<CallPickupState> {
  final CallStreamUsecase callUsecase;
  late final Stream<DocumentSnapshot> _callStream;

  CallPickupViewModel({required this.callUsecase})
      : super(CallPickupState(isLoading: true)) {
    _callStream = callUsecase.callStream;
    _listenToCallStream();
  }

  void _listenToCallStream() {
    _callStream.listen(
          (snapshot) {
        state = state.copyWith(snapshot: snapshot, isLoading: false);
      },
      onError: (err) {
        state = state.copyWith(error: err.toString(), isLoading: false);
      },
    );
  }

  void refresh() {
    state = CallPickupState(isLoading: true);
    _listenToCallStream();
  }

}
