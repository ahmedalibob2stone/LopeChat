import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecases/privacy/auto disappear message/get_default_disappear_timer_usecase.dart';
import '../../../../domain/usecases/privacy/auto disappear message/set_default_disappear_timer_usecase.dart';
class AutoDisappearState {
  final int? selectedIndex; // رقم الخيار المحدد
  final String? errorMessage;

  AutoDisappearState({
    this.selectedIndex,
    this.errorMessage,
  });

  AutoDisappearState copyWith({
    int? selectedIndex,
    String? errorMessage,
  }) {
    return AutoDisappearState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      errorMessage: errorMessage,
    );
  }
}

class AutoDisappearViewModel extends StateNotifier<AutoDisappearState> {
  final GetDefaultDisappearTimerUseCase getUseCase;
  final SetDefaultDisappearTimerUseCase setUseCase;

  // اختيارات المؤقت
  static const List<String> options = [
    '24 ساعة',
    '7 أيام',
    '90 يوماً',
    'إيقاف',
  ];

  AutoDisappearViewModel({
    required this.getUseCase,
    required this.setUseCase,
  }) : super(AutoDisappearState()) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    try {
      final timer = await getUseCase.call();

      if (timer == null) {
        state = state.copyWith(selectedIndex: null);
        return;
      }

      // تحويل النص الى index:
      int? index = options.indexWhere((element) => element == timer);

      // إذا لم يوجد تطابق اجعل الاختيار null
      if (index == -1) index = null;

      state = state.copyWith(selectedIndex: index);
    } catch (e) {
      // إدارة الخطأ (يمكن تغييرها لاحقاً لإظهار snackbar مثلا)
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> selectOption(int index) async {
    try {
      final selectedTimer = options[index];

      await setUseCase.call(selectedTimer);

      state = state.copyWith(selectedIndex: index, errorMessage: null);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}
