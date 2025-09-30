



import '../../../domain/entities/contact_entities.dart';

class ChatContactModel  extends ChatContactEntity   {
  ChatContactModel({
    required String name,
    required String prof,
    required String contactId,
    required DateTime time,
    required String lastMessage,
    required bool isOnline,
    required int unreadMessageCount,
    required String receiverId,
    required bool isSeen,
    required bool isArchived,

  }) : super(
    name: name,
    prof: prof,
    contactId: contactId,
    time: time,
    lastMessage: lastMessage,
    isOnline: isOnline,
    unreadMessageCount: unreadMessageCount,
    receiverId: receiverId,
    isSeen: isSeen,
    isArchived : isArchived,



  );

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] ?? '',
      prof: map['prof'] ?? '',
      contactId: map['contactId'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] ?? 0),
      lastMessage: map['lastMessage'] ?? '', // original typo: lastMassge
      isOnline: map['isOnline'] ?? '',
      unreadMessageCount: map['unreadMessageCount'] ?? 0,
      receiverId: map['receiverId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      isArchived: map['isArchived'] ?? false,


    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'prof': prof,
      'contactId': contactId,
      'time': time.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
      'isOnline': isOnline,
      'unreadMessageCount': unreadMessageCount,
      'receiverId': receiverId,
      'isSeen': isSeen,
      'isArchived':isArchived,


    };
  }
}
