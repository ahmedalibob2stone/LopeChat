import 'package:firebase_auth/firebase_auth.dart';

import '../../../../user/domain/entities/user_entity.dart';
import '../../repository/block/block_user_repository.dart';

class GetBlockedUsersUseCase {
  final BlockUserRepository blockRepository;
  final FirebaseAuth auth;
  GetBlockedUsersUseCase({
    required this.blockRepository,
    required this.auth,
  });

  Future<List<UserEntity>> execute() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return await blockRepository.getBlockedUsers(
      currentUserId: uid,
    );
  }
}
