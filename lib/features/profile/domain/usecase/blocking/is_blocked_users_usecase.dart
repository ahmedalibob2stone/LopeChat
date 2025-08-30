import '../../../data/model/block/block_privacy_model.dart';
import '../../repository/block/block_user_repository.dart';

class isBlockedUsersUseCase {
  final BlockUserRepository repository;

  isBlockedUsersUseCase(this.repository);


  Future<bool> isBlocked({required String currentUserId, required String otherUserId,
  })  {
    return repository.isBlocked(currentUserId: currentUserId, otherUserId:otherUserId);
  }
}
