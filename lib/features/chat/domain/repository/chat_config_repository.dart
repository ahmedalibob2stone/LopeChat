import '../entities/chat_config_entity.dart';

abstract class ChatRepository {
  Future<void> toggleDisappearingMessages({
    required String chatId,
    required bool isEnabled,
    required int durationSeconds,
  });

  Stream<DisappearingMessagesConfigEntity> getDisappearingMessagesConfig(String chatId);
}
