

import '../../entities/contact_entities.dart';
import '../../repository/chat_contact_repository.dart';

class SearchContactUseCase {
  final ChatContactRepository repository;

  SearchContactUseCase({required this.repository});

  Stream<List<ChatContactEntity>> execute(String searchName) {
    return repository.searchContact(searchName: searchName);
  }
}
