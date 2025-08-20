import '../../../../domain/entities/privacy/statu/statu_privacy_entity.dart';

class StatusPrivacyModel extends StatusPrivacyEntity {
  StatusPrivacyModel({
    required StatusPrivacyOption option,
    required List<String> excludedContactsIds,
    required List<String> includedContactsIds,
  }) : super(
    option: option,
    excludedContactsIds: excludedContactsIds,
    includedContactsIds: includedContactsIds,
  );

  factory StatusPrivacyModel.fromMap(Map<String, dynamic> map) {
    return StatusPrivacyModel(
      option: StatusPrivacyOption.values.firstWhere(
              (e) => e.toString() == 'StatusPrivacyOption.${map['option']}',
          orElse: () => StatusPrivacyOption.allContacts),
      excludedContactsIds: List<String>.from(map['excludedContactsIds'] ?? []),
      includedContactsIds: List<String>.from(map['includedContactsIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'option': option.toString().split('.').last,
      'excludedContactsIds': excludedContactsIds,
      'includedContactsIds': includedContactsIds,
    };
  }
}
