
import '../../../data/datasorce/chat_contact_remote_datasource.dart';
import '../../repository/chat_contact_repository.dart';
class UnarchiveChatUseCase {
  final ChatContactRepository repository;

  UnarchiveChatUseCase({required this.repository});

  Future<void> call(String chatId) {
    return repository.unarchiveChat(chatId);
  }
}

