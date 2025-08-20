// data/models/links_privacy_model.dart

import '../../../../../domain/entities/privacy/links/links_privacy_entity.dart';

class LinksPrivacyModel extends LinksPrivacyEntity {
  LinksPrivacyModel({
    required String visibility,
    List<String> exceptUids = const [],
  }) : super(visibility: visibility, exceptUids: exceptUids);

  factory LinksPrivacyModel.fromMap(Map<String, dynamic> map) {
    return LinksPrivacyModel(
      visibility: map['visibility'] ?? 'everyone',
      exceptUids: List<String>.from(map['except_uids'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'visibility': visibility,
      'except_uids': exceptUids,
    };
  }

  factory LinksPrivacyModel.fromEntity(LinksPrivacyEntity entity) {
    return LinksPrivacyModel(
      visibility: entity.visibility,
      exceptUids: entity.exceptUids,
    );
  }
}
