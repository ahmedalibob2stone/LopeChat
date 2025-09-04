

import '../../domain/entities/user_entity.dart';

class   UserModel extends UserEntity {
  const UserModel({
    required String name,
    required String uid,
    required String profile,
    required String isOnline,
    required String lastSeen,
    required String phoneNumber,
    required List<String> groupId,
    required String statu,
    required List<String> blockedUsers,

  }) : super(
    name: name,
    uid: uid,
    profile: profile,
    isOnline: isOnline,
      lastSeen:lastSeen,
    phoneNumber: phoneNumber,
    groupId: groupId,
    statu: statu,
    blockedUsers: blockedUsers
  );
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      name: entity.name,
      uid: entity.uid,
      profile: entity.profile,
      isOnline: entity.isOnline,
        lastSeen:entity.lastSeen,
      phoneNumber: entity.phoneNumber,
      groupId: entity.groupId,
      statu: entity.statu,
      blockedUsers:entity.blockedUsers
    );
  }
  UserEntity toEntity() {
    return UserEntity(
      name: name,
      uid: uid,
      profile: profile,
      isOnline: isOnline,
        lastSeen:lastSeen,
      phoneNumber: phoneNumber,
      groupId: groupId,
      statu: statu,
        blockedUsers:blockedUsers
    );
  }


  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profile: map['profile'] ?? '',
      isOnline: map['isOnline'] ?? '',
      lastSeen: map['lastSeen'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: map['groupId'] != null ? List<String>.from(map['groupId']) : [],
      statu: map['statu'] ?? '',
        blockedUsers: map['blockedUsers'] != null ? List<String>.from(map['blockedUsers'])
            : [],
      //blockedUsers
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profile': profile,
      'isOnline': isOnline,
      'lastSeen':lastSeen,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
      'statu': statu,
      'blockedUsers':blockedUsers
    };
  }
}
