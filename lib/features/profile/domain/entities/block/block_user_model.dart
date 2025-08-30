
class BlockEntity {
  final String blockId;
  final String blockedUserId;
  final DateTime blockedAt;

  const BlockEntity({
    required this.blockId,
    required this.blockedUserId,
    required this.blockedAt,
  });


}
