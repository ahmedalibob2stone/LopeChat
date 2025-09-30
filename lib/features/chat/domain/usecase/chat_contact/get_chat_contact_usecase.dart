import '../../entities/contact_entities.dart';
import '../../repository/chat_contact_repository.dart';

class GetChatContactsUseCase {
  final ChatContactRepository repository;

  GetChatContactsUseCase({required this.repository});

  Stream<List<ChatContactEntity>> call({required String userId}) {
    return repository.getChatContacts(userId: userId);
  }
}
