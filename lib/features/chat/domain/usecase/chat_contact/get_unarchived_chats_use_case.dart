
import '../../entities/contact_entities.dart';
import '../../repository/chat_contact_repository.dart';

class GetUnarchivedChatsUseCase {
  final ChatContactRepository repositiry;

  GetUnarchivedChatsUseCase({required this.repositiry});

  Stream<List<ChatContactEntity>> call() {
    return repositiry.getUnarchivedChats();
  }
}
