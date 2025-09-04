import '../../../../../user/domain/entities/user_entity.dart';
import '../../../../../user/data/user_model/user_model.dart';
import '../../../../domain/repository/privacy/block/block_privacy_repository.dart';
import '../../../datasource/privacy/block/block_privacy_remote_datasource.dart';

class BlockPrivacyRepositoryImpl implements BlockPrivacyRepository {
  final BlockPrivacyRemoteDataSource remoteDataSource;

  BlockPrivacyRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> blockUser(UserEntity user, String uid) {
    final userModel = UserModel(
      name: user.name,
      uid: user.uid,
      profile: user.profile,
      isOnline: user.isOnline,
      phoneNumber: user.phoneNumber,
      groupId: user.groupId, lastSeen: user.lastSeen
      , statu: user.statu, blockedUsers: [],
    );

    return remoteDataSource.blockUser(userModel, uid);
  }

  @override
  Future<void> unblockUser(UserEntity user, String uid) {
    final userModel = UserModel(
      name: user.name,
      uid: user.uid,
      profile: user.profile,
      isOnline: user.isOnline,
      phoneNumber: user.phoneNumber,
      groupId: user.groupId, lastSeen: '', statu: '', blockedUsers: [],
    );

    return remoteDataSource.unblockUser(userModel, uid);
  }

  @override
  Future<List<UserEntity>> getBlockedUsers(String uid) async {
    final blockedUserModels = await remoteDataSource.getBlockedUsers(uid);

    return blockedUserModels.map((model) => UserEntity(
      name: model.name,
      uid: model.uid,
      profile: model.profile,
      isOnline: model.isOnline,
      phoneNumber: model.phoneNumber,
      groupId: model.groupId, lastSeen: model.lastSeen, statu:model.statu, blockedUsers: [],
    )).toList();
  }
}
