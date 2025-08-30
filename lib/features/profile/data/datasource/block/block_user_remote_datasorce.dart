
import '../../../../user/model/user_model/user_model.dart';

abstract class BlockDataSource {
  Future<void> blockUser({
    required String currentUserId,
    required String  blockedUserId,
    required String blockedId
  });

  Future<void> unblockUser({
    required String currentUserId,
    required String block,

  });

  Future<bool> isBlocked({required String currentUserId, required String otherUserId,
  })  ;
  Future<void> clearMessages({
    required String currentUserId,
    required String chatId,
  });
  Future<List<UserModel>> getBlockedUsers({required String currentUserId});
  }
