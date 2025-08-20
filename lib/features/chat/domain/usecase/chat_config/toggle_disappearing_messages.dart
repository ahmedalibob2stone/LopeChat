import '../../repository/chat_config_repository.dart';

class ToggleDisappearingMessagesUseCase {
  final ChatRepository repository;

  ToggleDisappearingMessagesUseCase(this.repository);

  Future<void> call({
    required String chatId,
    required bool isEnabled,
    required int durationSeconds,
  }) async {
    await repository.toggleDisappearingMessages(
      chatId: chatId,
      isEnabled: isEnabled,
      durationSeconds: durationSeconds,
    );
  }
}
