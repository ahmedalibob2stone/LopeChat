import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/status_entity.dart';
import '../domain/usecases/delet_statuses_usecase.dart';
import '../domain/usecases/get_statuses_usecase.dart';
import '../domain/usecases/provider/upload_status_usecase_provider.dart';




class StatusListState {
  final bool isLoading;
  final List<StatusEntity> statuses;
  final String? error;

  StatusListState({
    this.isLoading = false,
    this.statuses = const [],
    this.error,
  });

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

class StatusListViewModel extends StateNotifier<StatusListState> {
  final GetStatusesUseCase getUseCase;
  final DeleteStatusUseCase deleteUseCase;

  StatusListViewModel(this.getUseCase, this.deleteUseCase)
      : super(StatusListState());

  Future<void> loadStatuses() async {
    try {
      state = StatusListState(isLoading: true);
      final statuses = await getUseCase();
      state = StatusListState(statuses: statuses);
    } catch (e) {
      state = StatusListState(error: e.toString());
    }
  }

  Future<bool> deleteStatus(int index, List<String> photoUrls) async {
    final success = await deleteUseCase(index: index, photoUrls: photoUrls);
    if (success) {
      await loadStatuses(); // Reload data
      return true; // هنا ترجع نجاح
    } else {
      state = state.copyWith(error: 'Failed to delete status');
      return false; // ترجع فشل
    }
  }
}
