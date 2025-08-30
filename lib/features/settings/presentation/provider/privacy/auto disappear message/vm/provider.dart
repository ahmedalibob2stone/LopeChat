import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/privacy/auto disappear message/auto_disappearViewModel.dart';
import '../usecases/get_default_disappear_massage_usecase_provider.dart';
import '../usecases/set_default_disappear_massage_usecase_provider.dart';

final autoDisappearViewModelProvider = StateNotifierProvider<AutoDisappearViewModel, AutoDisappearState>((ref) {
  final getUseCase = ref.watch(getDefaultDisappearTimerUseCaseProvider);
  final setUseCase = ref.watch(setDefaultDisappearTimerUseCaseProvider);
  return AutoDisappearViewModel(getUseCase: getUseCase, setUseCase: setUseCase);
});
