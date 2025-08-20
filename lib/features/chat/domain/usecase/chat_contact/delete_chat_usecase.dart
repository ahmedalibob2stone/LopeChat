
import '../../repository/chat_contact_repository.dart';

class DeleteChatUseCase {
  final ChatContactRepository repository;

  DeleteChatUseCase(this.repository);

  Future<void> call({required String receiverId}) {
    return repository.deleteChat(receiverId: receiverId);
  }
}
