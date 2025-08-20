import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodel/chat_config/disappearing_massages_viewmodel.dart';
import '../usecase/provider.dart';

final disappearingMessagesViewModelProvider = StateNotifierProvider<
    DisappearingMessagesViewModel, DisappearingMessagesState>((ref) {
  final toggleUseCase = ref.watch(toggleDisappearingMessagesUseCaseProvider);
  final getConfigUseCase = ref.watch(getDisappearingMessagesConfigUseCaseProvider);
  return DisappearingMessagesViewModel(
    toggleUseCase: toggleUseCase,
    getConfigUseCase: getConfigUseCase,
  );
});
