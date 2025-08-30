import '../../../../domain/entities/privacy/privacy_profile/privacy_profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.visibility,
    required super.exceptUids,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      visibility: map['visibility'] ?? 'everyone',
      exceptUids: List<String>.from(map['exceptUids'] ?? []),
    );
  }
  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      visibility: entity.visibility,
      exceptUids: entity.exceptUids,
    );
  }
  ProfileEntity toEntity() {
    return ProfileEntity(
      visibility: visibility,
      exceptUids: exceptUids,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'visibility': visibility,
      'exceptUids': exceptUids,
    };
  }
}
