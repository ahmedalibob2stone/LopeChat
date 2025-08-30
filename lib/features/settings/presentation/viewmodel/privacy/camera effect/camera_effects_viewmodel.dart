import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecases/privacy/camera effect/get_camera_effects_usecase.dart';
import '../../../../domain/usecases/privacy/camera effect/set_camera_effects_usecase.dart';

class CameraEffectsState {
  final bool isEnabled;
  final bool isLoading;

  CameraEffectsState({required this.isEnabled, this.isLoading = false});

  CameraEffectsState copyWith({bool? isEnabled, bool? isLoading}) {
    return CameraEffectsState(
      isEnabled: isEnabled ?? this.isEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CameraEffectsViewModel extends StateNotifier<CameraEffectsState> {
  final GetCameraEffectsStatusUseCase getUseCase;
  final SetCameraEffectsStatusUseCase setUseCase;

  CameraEffectsViewModel({
    required this.getUseCase,
    required this.setUseCase,
  }) : super(CameraEffectsState(isEnabled: false)) {
    loadStatus();
  }

  Future<void> loadStatus() async {
    state = state.copyWith(isLoading: true);
    final enabled = await getUseCase.call();
    state = state.copyWith(isEnabled: enabled, isLoading: false);
  }

  Future<void> toggleEffects(bool enable, {required Function(bool)? onDialogCancel}) async {
    if (!enable) {
      // عند إيقاف التشغيل نعرض dialog
      // ندعو onDialogCancel(false) لو تم الإلغاء
      // يتم تفعيل أو إلغاء تفعيل التأثيرات بناء على رد المستخدم من dialog (سيتم من UI)
      state = state.copyWith(isLoading: true);
      // لكن في ال dialog سيكون هناك إلغاء أو تأكيد
    } else {
      // تفعيل مباشر
      await setUseCase.call(true);
      state = state.copyWith(isEnabled: true, isLoading: false);
    }
  }

  Future<void> setStatus(bool enable) async {
    await setUseCase.call(enable);
    state = state.copyWith(isEnabled: enable, isLoading: false);
  }
}


