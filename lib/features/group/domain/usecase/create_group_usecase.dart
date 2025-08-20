import 'dart:io';

import 'package:flutter_contacts/contact.dart';

import '../repository/group_repository.dart';


class CreateGroupUseCase {
  final IGroupRepository repository;

  CreateGroupUseCase(this.repository);

  Future<void> execute({
    required String name,
    required File profile,
    required List<Contact> selectedContacts,
  }) {
    return repository.createGroup(name: name, profile: profile, selectedContacts: selectedContacts);
  }
}
