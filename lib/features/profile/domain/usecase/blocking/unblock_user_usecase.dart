

import '../../repository/block/block_user_repository.dart';

class UnblockUserUseCase {
  final BlockUserRepository repository;

  UnblockUserUseCase(this.repository);

  Future<void> call({
    required String currentUserId,
    required String block,
  }) async {
    return repository.unblockUser(currentUserId: currentUserId, block:block);

  }
}
