
import 'package:firebase_auth/firebase_auth.dart';

import '../../../entities/privacy/group/group_privacy_entity.dart';
import '../../../repository/privacy/group/group_privacy_repository.dart';

class UpdateGroupPrivacyUseCase {
  final GroupPrivacyRepository repository;
  final FirebaseAuth auth;

  UpdateGroupPrivacyUseCase({required this.repository, required this.auth});

  Future<void> call(GroupPrivacyEntity entity) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not authenticated");
    final uid = user.uid;

    await repository.updateGroupPrivacy(entity, uid);
  }
}