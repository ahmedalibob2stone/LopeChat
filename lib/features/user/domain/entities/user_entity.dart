
class UserEntity {
  final String name;
  final String uid;
  final String profile;
  final bool  isOnline;
  final String lastSeen;
  final String phoneNumber;
  final List<String> groupId;
  final String statu;
  final List<String> blockedUsers;

  const UserEntity({
    required this.name,
    required this.uid,
    required this.profile,
    required this.isOnline,
    required this.lastSeen,
    required this.phoneNumber,
    required this.groupId,
    required this.statu,
    required this.blockedUsers
  });
  factory UserEntity.empty() => UserEntity(uid: '', name: 'Guest', profile: '', isOnline: false, lastSeen: '', phoneNumber: '', groupId: [], statu: '', blockedUsers: []);

}
