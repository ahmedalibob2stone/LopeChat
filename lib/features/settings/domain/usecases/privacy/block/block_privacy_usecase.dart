import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../user/domain/entities/user_entity.dart';
import '../../../repository/privacy/block/block_privacy_repository.dart';

class BlockPrivacyUserUseCase {
  final BlockPrivacyRepository repository;
  final FirebaseAuth auth;

  BlockPrivacyUserUseCase(this.repository, this.auth);

  Future<void> call(UserEntity user) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    await repository.blockUser(user,uid);
  }
}


