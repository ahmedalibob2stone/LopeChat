class GroupEntity {
  final String groupId;
  final String ownerUid;
  final List<String> adminUids;
  final List<String> membersUid;
  final String name;
  final String groupPic;
  final String lastMessage;
  final int timeSent;
  final Map<String, int> unreadMessageCount;
  final List<String> archivedUsers;

  GroupEntity({
    required this.groupId,
    required this.ownerUid,
    required this.adminUids,
    required this.membersUid,
    required this.name,
    required this.groupPic,
    required this.lastMessage,
    required this.timeSent,
    required this.unreadMessageCount,
    required this.archivedUsers
  });
}
