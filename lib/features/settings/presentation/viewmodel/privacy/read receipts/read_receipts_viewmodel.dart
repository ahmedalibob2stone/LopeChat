import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecases/privacy/read_receipts/get_read_receipts_usecase.dart';
import '../../../../domain/usecases/privacy/read_receipts/update_read_receipts_usecase.dart';

class ReadReceiptsState {
  final bool isLoading;
  final bool readReceiptsEnabled;
  final String? errorMessage;
  final String? successMessage;

  const ReadReceiptsState({
    this.isLoading = false,
    this.readReceiptsEnabled = false,
    this.errorMessage,
    this.successMessage,
  });

  ReadReceiptsState copyWith({
    bool? isLoading,
    bool? readReceiptsEnabled,
    String? errorMessage,
    String? successMessage,
  }) {
    return ReadReceiptsState(
      isLoading: isLoading ?? this.isLoading,
      readReceiptsEnabled: readReceiptsEnabled ?? this.readReceiptsEnabled,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  factory ReadReceiptsState.initial() => const ReadReceiptsState();
}


class ReadReceiptsViewModel extends StateNotifier<ReadReceiptsState> {
  final GetReadReceiptsUseCase _getUseCase;
  final
  _updateUseCase;

  ReadReceiptsViewModel(this._getUseCase, this._updateUseCase)
      : super(ReadReceiptsState.initial()) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await _getUseCase();
      state = state.copyWith(
        readReceiptsEnabled: result.readReceiptsEnabled,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'فشل في تحميل مؤشرات القراءة',
      );
    }
  }

  Future<void> toggleReadReceipts(bool enabled) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      state = state.copyWith(errorMessage: 'لا يوجد اتصال بالإنترنت');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);

    try {
      await _updateUseCase(enabled);
      state = state.copyWith(
        readReceiptsEnabled: enabled,
        isLoading: false,
        successMessage: enabled
            ? 'تم تفعيل مؤشرات القراءة'
            : 'تم إيقاف مؤشرات القراءة',
      );
    } catch (e) {
      final result = await _getUseCase();
      state = state.copyWith(
        isLoading: false,
        readReceiptsEnabled: result.readReceiptsEnabled,
        errorMessage: 'فشل في تحديث مؤشرات القراءة',
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}
