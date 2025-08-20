import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/report/report_use_usecase.dart';

class ReportState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  ReportState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  ReportState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class ReportViewModel extends StateNotifier<ReportState> {
  final ReportUserUseCase reportUserUseCase;

  ReportViewModel({required this.reportUserUseCase}) : super(ReportState());

  Future<void> reportUser({
    required String reportedUserId,
    required String reason,

  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);

      await reportUserUseCase.call(
        reportedUserId: reportedUserId,
        reason: reason,

      );

      state = state.copyWith(
        isLoading: false,
        successMessage: 'تم إرسال البلاغ بنجاح',
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        successMessage: null,
        errorMessage: e.toString(),
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}
