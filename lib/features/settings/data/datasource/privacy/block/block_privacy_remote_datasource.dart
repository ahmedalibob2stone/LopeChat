import '../../../../../user/domain/entities/user_entity.dart';
import '../../../../../user/model/user_model/user_model.dart';

abstract class BlockPrivacyRemoteDataSource {
  Future<void> blockUser(UserModel user,String uid);
  Future<void> unblockUser(UserModel user,String uid);
  Future<List<UserModel>> getBlockedUsers(String uid);
}
