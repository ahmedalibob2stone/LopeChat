import '../../../../domain/entities/privacy/about/privacy_about_entity.dart';

class PrivacyAboutModel extends PrivacyAboutEntity {
  PrivacyAboutModel({
    required super.visibility,
    required super.exceptUids,
  });

  factory PrivacyAboutModel.fromMap(Map<String, dynamic> map) {
    return PrivacyAboutModel(
      visibility: map['visibility'] ?? 'everyone',
      exceptUids: List<String>.from(map['exceptUids'] ?? []),
    );
  }
  factory PrivacyAboutModel.fromEntity(PrivacyAboutEntity entity) {
    return PrivacyAboutModel(
      visibility: entity.visibility,
      exceptUids: entity.exceptUids,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'visibility': visibility,
      'exceptUids': exceptUids,
    };
  }
}
