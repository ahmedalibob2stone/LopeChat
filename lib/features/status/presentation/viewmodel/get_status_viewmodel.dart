
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

  // دالة copyWith لتحديث الحالة بشكل مريح
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

  GetStatusesViewModel(this.getUseCase) : super(StatusListState());

  Future<void> loadStatuses() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final statuses = await getUseCase();
      state = state.copyWith(isLoading: false, statuses: statuses, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}