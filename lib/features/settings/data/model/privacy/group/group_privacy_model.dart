
import '../../../../domain/entities/privacy/group/group_privacy_entity.dart';

class GroupPrivacyModel extends GroupPrivacyEntity {
  const GroupPrivacyModel({
    required super.visibility,
    required super.exceptUids,
  });

  factory GroupPrivacyModel.fromMap(Map<String, dynamic> map) {
    return GroupPrivacyModel(
      visibility: map['visibility'] ?? 'everyone',
      exceptUids: List<String>.from(map['exceptUids'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'visibility': visibility,
      'exceptUids': exceptUids,
    };
  }

  factory GroupPrivacyModel.fromEntity(GroupPrivacyEntity entity) {
    return GroupPrivacyModel(
      visibility: entity.visibility,
      exceptUids: entity.exceptUids,
    );
  }
}
