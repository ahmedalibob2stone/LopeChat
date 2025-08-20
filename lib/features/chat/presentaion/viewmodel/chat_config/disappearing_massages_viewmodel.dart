import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/chat_config/get_disappearing_messages.dart';
import '../../../domain/usecase/chat_config/toggle_disappearing_messages.dart';




class DisappearingMessagesState {
  final bool isEnabled;
  final int durationSeconds;
  final bool isLoading;
  final String? errorMessage;

  DisappearingMessagesState({
    this.isEnabled = false,
    this.durationSeconds = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  DisappearingMessagesState copyWith({
    bool? isEnabled,
    int? durationSeconds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DisappearingMessagesState(
      isEnabled: isEnabled ?? this.isEnabled,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class DisappearingMessagesViewModel extends StateNotifier<DisappearingMessagesState> {
  final ToggleDisappearingMessagesUseCase toggleUseCase;
  final GetDisappearingMessagesConfigUseCase getConfigUseCase;

  DisappearingMessagesViewModel({
    required this.toggleUseCase,
    required this.getConfigUseCase,
  }) : super(DisappearingMessagesState());

  void listenToConfig(String chatId) {
    getConfigUseCase(chatId).listen((config) {
      state = state.copyWith(
        isEnabled: config.isEnabled,
        durationSeconds: config.durationSeconds,
      );
    });
  }

  Future<void> toggleDisappearingMessages(String chatId, bool enable, int duration) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await toggleUseCase(
        chatId: chatId,
        isEnabled: enable,
        durationSeconds: duration,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
