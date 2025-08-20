import 'package:firebase_auth/firebase_auth.dart';

import '../../../entities/privacy/group/group_privacy_entity.dart';
import '../../../repository/privacy/group/group_privacy_repository.dart';

class GetGroupPrivacyUseCase {
  final GroupPrivacyRepository repository;
  final FirebaseAuth auth;

  GetGroupPrivacyUseCase({required this.repository, required this.auth});

  Future<GroupPrivacyEntity> call() async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not authenticated");
    final uid = user.uid;

    return repository.getGroupPrivacy(uid);
  }
}