import '../../repository/block/block_user_repository.dart';
import 'package:uuid/uuid.dart';

class BlockUserUseCase {
  final BlockUserRepository repository;

  BlockUserUseCase(this.repository);

  Future<void> execute({
    required String currentUserId,
    required String blockedUserId,
  }) {
    final newBlockId =  Uuid().v4();


    return repository.blockUser(currentUserId: currentUserId, blockedUserId: blockedUserId, blockedId: newBlockId);
  }
}
