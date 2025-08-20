

import '../../../../user/model/user_model/user_model.dart';
import '../../../domain/repository/block/block_user_repository.dart';
import '../../datasource/block/block_user_remote_datasorce.dart';

class BlockUserRepositoryImpl implements BlockUserRepository {
  final BlockDataSource blockDataSource;

  BlockUserRepositoryImpl(this.blockDataSource);

  @override
  Future<void> blockUser({
    required String currentUserId,
    required String blockedUserId,
    required String blockedId
  }) {
    return blockDataSource.blockUser(currentUserId: currentUserId, blockedUserId: blockedUserId, blockedId: blockedId);
  }

  @override
  Future<void> unblockUser({
    required String currentUserId,
    required String block,
  }) {


    return blockDataSource.unblockUser(
      currentUserId: currentUserId,
      block: block
    );
  }

  @override

  Future<bool> isBlocked({required String currentUserId, required String otherUserId,
  })   async{
    return blockDataSource.isBlocked(currentUserId: currentUserId, otherUserId: otherUserId,);
  }
  @override
  Future<void> clearMessages({
    required String currentUserId,
    required String chatId,
  }) {
    return blockDataSource.clearMessages(
      currentUserId: currentUserId,
      chatId: chatId,
    );
  }
  @override
  Future<List<UserModel>> getBlockedUsers({required String currentUserId}) async {
    return await blockDataSource.getBlockedUsers(currentUserId: currentUserId);
  }
}

