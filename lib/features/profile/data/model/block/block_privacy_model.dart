import '../../../domain/entities/block/block_user_model.dart';

class BlockModel extends BlockEntity {
  const BlockModel({
    required super.blockId,
    required super.blockedUserId,
    required super.blockedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'blockId': blockId,
      'blockedUserId': blockedUserId,
      'blockedAt': blockedAt.millisecondsSinceEpoch,
    };
  }

  factory BlockModel.fromMap(Map<String, dynamic> map, String docId) {
    return BlockModel(
      blockId: docId,
      blockedUserId: map['blockedUserId'] ?? '',
      blockedAt: DateTime.fromMillisecondsSinceEpoch(
        map['blockedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
