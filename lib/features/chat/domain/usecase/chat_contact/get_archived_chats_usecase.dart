import '../../../data/datasorce/chat_contact_remote_datasource.dart';
import '../../entities/contact_entities.dart';
import '../../repository/chat_contact_repository.dart';

class GetArchivedChatsUseCase {
  final ChatContactRepository repository;

  GetArchivedChatsUseCase({required this.repository});

  Stream<List<ChatContactEntity>> call() {
    return repository.getArchivedChats();
  }
}
