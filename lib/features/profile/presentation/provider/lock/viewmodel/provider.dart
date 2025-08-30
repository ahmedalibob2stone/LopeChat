import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodel/lock/lock_viewmodel.dart';
import '../usecases/provider.dart';

final chatLockViewModelProvider =
StateNotifierProvider.family<ChatLockViewModel, ChatLockState, String>(
(ref, chatId) {
final isChatLockedUseCase = ref.read(isChatLockedUseCaseProvider);
final lockChatUseCase = ref.read(lockChatUseCaseProvider);
final unlockChatUseCase = ref.read(unlockChatUseCaseProvider);

final viewModel = ChatLockViewModel(
isChatLockedUseCase: isChatLockedUseCase,
lockChatUseCase: lockChatUseCase,
unlockChatUseCase: unlockChatUseCase,
);
viewModel.loadLockState(chatId);

return viewModel;
});