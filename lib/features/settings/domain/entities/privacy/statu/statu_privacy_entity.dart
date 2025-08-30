enum StatusPrivacyOption {
  allContacts,
  contactsExcept,
  shareWithOnly,
}

class StatusPrivacyEntity {
  final StatusPrivacyOption option;
  final List<String> excludedContactsIds; // جهات الاتصال المستثناة
  final List<String> includedContactsIds; // جهات الاتصال المضمّنة

  StatusPrivacyEntity({
    required this.option,
    required this.excludedContactsIds,
    required this.includedContactsIds,
  });
}
