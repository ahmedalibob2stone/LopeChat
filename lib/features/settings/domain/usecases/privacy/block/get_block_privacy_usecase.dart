import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../user/domain/entities/user_entity.dart';
import '../../../repository/privacy/block/block_privacy_repository.dart';

class GetBlockedPrivacyUsersUseCase {
  final BlockPrivacyRepository repository;
  final FirebaseAuth auth;

  GetBlockedPrivacyUsersUseCase(this.repository, this.auth);

  Future<List<UserEntity>> call() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return repository.getBlockedUsers(uid);
  }
}
