import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/check internat/check_internat.dart';
import '../../domain/usecases/upload_status_usecase.dart';

class UploadStatusState {
  final bool isLoading;
  final bool success;
  final String? error;
  final String? message;

  const UploadStatusState({
    this.isLoading = false,
    this.success = false,
    this.error,
    this.message,
  });

  UploadStatusState copyWith({
    bool? isLoading,
    bool? success,
    String? error,
    String? message,
  }) {
    return UploadStatusState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      error: error,
      message: message ?? this.message,
    );
  }

  factory UploadStatusState.initial() => const UploadStatusState();
}

class UploadStatusViewModel extends StateNotifier<UploadStatusState> {
  final UploadStatusUseCase useCase;

  UploadStatusViewModel({required this.useCase})
      : super(UploadStatusState.initial());

  /// الدالة الأساسية لإضافة حالة جديدة
  Future<void> uploadStatus({
    required File file,
    required String message,
    required String username,
    required String profile,
    required String phoneNumber,
    required Map<String, List<String>> seenBy,
  }) async {
    state = const UploadStatusState(isLoading: true);

    final connected = await CheckInternet.isConnected();
    if (!connected) {
      // عند فشل الإنترنت يجب إيقاف loading وتحديث error
      state = state.copyWith(
        isLoading: false,
        error: "No internet connection. Please try again.",
      );
      return;
    }


    // 🔹 2- محاولة رفع الحالة عبر UseCase
    try {
      await useCase.call(
        username: username,
        profilePic: profile,
        phoneNumber: phoneNumber,
        statusImage: file,
        statusMessage: message,
        seenBy: seenBy,
      );

      // 🔹 3- نجاح العملية
      state = const UploadStatusState(
        success: true,
        message: "✅ تم رفع الحالة بنجاح",
      );
    } catch (e) {
      // 🔹 4- خطأ عام أثناء الرفع (مثل Firebase)
      _setError("❌ حدث خطأ أثناء رفع الحالة. الرجاء المحاولة مرة أخرى.");
    }
  }

  void _setError(String msg) {
    state = UploadStatusState(error: msg);
  }

  void resetState() {
    state = UploadStatusState.initial();
  }
}
