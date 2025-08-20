
import '../../../domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required String groupId,
    required String ownerUid,
    required List<String> adminUids,
    required List<String> membersUid,
    required String name,
    required String groupPic,
    required String lastMessage,
    required int timeSent,
    required Map<String, int> unreadMessageCount,
    required List<String> archivedUsers,
  }) : super(
    groupId: groupId,
    ownerUid: ownerUid,
    adminUids: adminUids,
    membersUid: membersUid,
    name: name,
    groupPic: groupPic,
    lastMessage: lastMessage,
    timeSent: timeSent,
    unreadMessageCount: unreadMessageCount,
      archivedUsers: archivedUsers
  );

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map['groupId'] ?? '',
      ownerUid: map['ownerUid'] ?? '',
      adminUids: List<String>.from(map['adminUids'] ?? []),
      membersUid: List<String>.from(map['membersUid'] ?? []),
      name: map['name'] ?? '',
      groupPic: map['groupPic'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      timeSent: map['timeSent'] ?? 0,
      unreadMessageCount: Map<String, int>.from(map['unreadMessageCount'] ?? {}),
      archivedUsers: List<String>.from(map['archivedUsers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'ownerUid': ownerUid,
      'adminUids': adminUids,
      'membersUid': membersUid,
      'name': name,
      'groupPic': groupPic,
      'lastMessage': lastMessage,
      'timeSent': timeSent,
      'unreadMessageCount': unreadMessageCount,
      'archivedUsers':archivedUsers
    };
  }

  // تحويل من Model إلى Entity
  GroupEntity toEntity() {
    return GroupEntity(
      groupId: groupId,
      ownerUid: ownerUid,
      adminUids: adminUids,
      membersUid: membersUid,
      name: name,
      groupPic: groupPic,
      lastMessage: lastMessage,
      timeSent: timeSent,
      unreadMessageCount: unreadMessageCount,
        archivedUsers:archivedUsers
    );
  }

  // تحويل من Entity إلى Model
  factory GroupModel.fromEntity(GroupEntity entity) {
    return GroupModel(
      groupId: entity.groupId,
      ownerUid: entity.ownerUid,
      adminUids: entity.adminUids,
      membersUid: entity.membersUid,
      name: entity.name,
      groupPic: entity.groupPic,
      lastMessage: entity.lastMessage,
      timeSent: entity.timeSent,
      unreadMessageCount: entity.unreadMessageCount,
        archivedUsers: entity.archivedUsers
    );
  }
}
