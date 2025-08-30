
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entites/callentites.dart';
import '../../domain/usecase/delete_call_use_case.dart';
import '../../domain/usecase/get_stream_calls_usecase.dart';

class CallHistoryState {
  final List<CallEntites> callHistory;
  final bool isLoading;
  final String? error;

  CallHistoryState({
    this.callHistory = const [],
    this.isLoading = false,
    this.error,
  });

  CallHistoryState copyWith({
    List<CallEntites>? callHistory,
    bool? isLoading,
    String? error,
  }) {
    return CallHistoryState(
      callHistory: callHistory ?? this.callHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CallHistoryViewModel extends StateNotifier<CallHistoryState> {
  final GetStreamCallsUseCase getStreamCallsUseCase;
  final DeleteCallUseCase deleteCallUseCase;
  CallHistoryViewModel({required this.getStreamCallsUseCase,required this.deleteCallUseCase})
      : super(CallHistoryState()) {
    _loadCallHistory();
  }

  void _loadCallHistory() {
    state = state.copyWith(isLoading: true);

    getStreamCallsUseCase().listen(
          (calls) {
        state = state.copyWith(callHistory: calls, isLoading: false);
      },
      onError: (error) {
        state = state.copyWith(error: error.toString(), isLoading: false);
      },
    );
  }
  void deleteCall(String currentUserId) {
    deleteCallUseCase.call(currentUserId);
  }
}
