import 'package:flutter_contacts/contact.dart';

import '../repository/group_repository.dart';


class AddUsersToGroupUseCase {
  final IGroupRepository repository;

  AddUsersToGroupUseCase(this.repository);

  Future<void> execute({
    required List<Contact> selectedContacts,
    required String groupId,
  }) {
    return repository.addUsersToGroup(selectedContacts: selectedContacts, groupId: groupId);
  }
}

