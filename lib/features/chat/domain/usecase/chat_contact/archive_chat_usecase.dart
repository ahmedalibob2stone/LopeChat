
import '../../repository/chat_contact_repository.dart';
class ArchiveChatUseCase {
  final ChatContactRepository repository;

  ArchiveChatUseCase({required this.repository});

  Future<void> call(String chatId) {
    return repository.archiveChat(chatId);
  }
}

