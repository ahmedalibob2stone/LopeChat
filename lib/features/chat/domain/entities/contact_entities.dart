class ChatContactEntity {
  final String name;
  final String prof;
  final String contactId;
  final DateTime time;
  final String lastMessage;
  final bool isOnline;
  final int unreadMessageCount;
  final String receiverId;
  final bool isSeen;
  final bool isArchived;

  ChatContactEntity({
    required this.name,
    required this.prof,
    required this.contactId,
    required this.time,
    required this.lastMessage,
    required this.isOnline,
    required this.unreadMessageCount,
    required this.receiverId,
    required this.isSeen,
    required this.isArchived,

  });
}
