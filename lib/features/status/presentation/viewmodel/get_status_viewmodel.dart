import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/status_entity.dart';
import '../../domain/usecases/get_statuses_usecase.dart';

class StatusListState {
  final bool isLoading;
  final List<StatusEntity> statuses;
  final String? error;

  StatusListState({
    this.isLoading = false,
    List<StatusEntity>? statuses,
    this.error,
  }) : statuses = statuses ?? [];

  StatusListState copyWith({
    bool? isLoading,
    List<StatusEntity>? statuses,
    String? error,
  }) {
    return StatusListState(
      isLoading: isLoading ?? this.isLoading,
      statuses: statuses ?? this.statuses,
      error: error,
    );
  }
}

class GetStatusesViewModel extends StateNotifier<StatusListState> {
  final GetStatusesUseCase getUseCase;
  late final Stream<List<StatusEntity>> _statusStream;
  late final StreamSubscription<List<StatusEntity>> _subscription;

  GetStatusesViewModel(this.getUseCase) : super(StatusListState()) {
    _statusStream = getUseCase(); // استدعاء الدالة Stream من UseCase
    _subscription = _statusStream.listen(
          (statuses) {
        state = state.copyWith(isLoading: false, statuses: statuses, error: null);
      },
      onError: (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
