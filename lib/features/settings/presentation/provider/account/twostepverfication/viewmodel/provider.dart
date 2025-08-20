import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/acount/twostep/two_step_verfication_viewmodel.dart';
import '../usecases/provider.dart';

final twoStepVerificationViewModelProvider =
StateNotifierProvider<TwoStepVerificationViewModel, TwoStepVerificationState>((ref) {
  final getStatusUseCase = ref.watch(getTwoStepStatusUseCaseProvider);
  final setStatusUseCase = ref.watch(setTwoStepStatusUseCaseProvider);
  final getPinUseCase = ref.watch(getPinUseCaseProvider);
  final setPinUseCase = ref.watch(setPinUseCaseProvider);

  return TwoStepVerificationViewModel(
    getStatusUseCase: getStatusUseCase,
    setStatusUseCase: setStatusUseCase,
    getPinUseCase: getPinUseCase,
    setPinUseCase: setPinUseCase,
  );
});
