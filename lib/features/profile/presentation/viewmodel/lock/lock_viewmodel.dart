import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/lock/Ischat_locked_usecase.dart';
import '../../../domain/usecase/lock/lock_chat_usecase.dart';
import '../../../domain/usecase/lock/unlock_chat_usecase.dart';
class ChatLockState {
  final bool isLocked;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  ChatLockState({
    required this.isLocked,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  ChatLockState copyWith({
    bool? isLocked,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ChatLockState(
      isLocked: isLocked ?? this.isLocked,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}


// ViewModel
class ChatLockViewModel extends StateNotifier<ChatLockState> {
  final IsChatLockedUseCase isChatLockedUseCase;
  final LockChatUseCase lockChatUseCase;
  final UnlockChatUseCase unlockChatUseCase;

  ChatLockViewModel({
    required this.isChatLockedUseCase,
    required this.lockChatUseCase,
    required this.unlockChatUseCase,
  }) : super(ChatLockState(isLocked: false));

  Future<void> lockChat(String chatId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
      await lockChatUseCase.call(chatId);
      state = state.copyWith(
        isLocked: true,
        isLoading: false,
        successMessage: 'تم قفل المحادثة بنجاح',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }


  void clearMessages() {
    state = state.copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }

  Future<void> unlockChat(String chatId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
      await unlockChatUseCase.call(chatId);
      state = state.copyWith(
        isLocked: false,
        isLoading: false,
        successMessage: 'تم فتح المحادثة بنجاح',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
  Future<void> loadLockState(String chatId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
      final isLocked = await isChatLockedUseCase.call(chatId);
      state = state.copyWith(
        isLocked: isLocked,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> toggleLock(String chatId) async {
    if (state.isLocked) {
      await unlockChat(chatId);
    } else {
      await lockChat(chatId);
    }
  }
}
