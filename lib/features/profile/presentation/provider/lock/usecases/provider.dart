
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecase/lock/Ischat_locked_usecase.dart';
import '../../../../domain/usecase/lock/lock_chat_usecase.dart';
import '../../../../domain/usecase/lock/unlock_chat_usecase.dart';
import '../data/provider.dart';

final lockChatUseCaseProvider = Provider<LockChatUseCase>((ref) {
  final repository = ref.watch(chatLockRepositoryProvider);
  return LockChatUseCase(repository);
});
final unlockChatUseCaseProvider = Provider<UnlockChatUseCase>((ref) {
  final repository = ref.watch(chatLockRepositoryProvider);
  return UnlockChatUseCase(repository);
});

final isChatLockedUseCaseProvider = Provider<IsChatLockedUseCase>((ref) {
  final repository = ref.watch(chatLockRepositoryProvider);
  return IsChatLockedUseCase(repository);
});