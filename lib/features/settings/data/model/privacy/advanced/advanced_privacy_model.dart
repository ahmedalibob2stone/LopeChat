import '../../../../domain/entities/privacy/advanced/advanced_privacy_entity.dart';

class AdvancedPrivacyModel extends AdvancedPrivacyEntity {
  const AdvancedPrivacyModel({
    required bool blockUnknownSenders,
  }) : super(blockUnknownSenders: blockUnknownSenders);

  factory AdvancedPrivacyModel.fromMap(Map<String, dynamic> map) {
    return AdvancedPrivacyModel(
      blockUnknownSenders: map['blockUnknownSenders'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blockUnknownSenders': blockUnknownSenders,
    };
  }
}
