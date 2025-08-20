import '../../../../../user/domain/entities/user_entity.dart';

abstract class BlockPrivacyRepository {
  Future<void> blockUser( UserEntity user, String uid);
  Future<void> unblockUser(UserEntity user, String uid);
  Future<List<UserEntity>> getBlockedUsers(String uid);
}
