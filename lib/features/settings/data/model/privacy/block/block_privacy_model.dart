import '../../../../domain/entities/privacy/block/block_privacy_entity.dart';

class BlockPrivacyModel extends BlockPrivacyEntity {
  const BlockPrivacyModel({
    required List<String> blockedList,
  }) : super(blockedList: blockedList);

  factory BlockPrivacyModel.fromMap(Map<String, dynamic> map) {
    return BlockPrivacyModel(
      blockedList: List<String>.from(map['blockedList'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blockedList': blockedList,
    };
  }
}
