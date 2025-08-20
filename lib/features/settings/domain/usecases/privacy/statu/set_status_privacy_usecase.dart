import 'package:firebase_auth/firebase_auth.dart';

import '../../../entities/privacy/statu/statu_privacy_entity.dart';
import '../../../repository/privacy/statu/status_privacy_repository.dart';

class SetStatusPrivacyUseCase {
  final StatusPrivacyRepository repository;
  final FirebaseAuth auth;

  SetStatusPrivacyUseCase({
    required this.repository,
    required this.auth,
  });

  Future<void> call(StatusPrivacyEntity entity) async {
    final user = auth.currentUser;
    if (user == null) return;

    await repository.saveStatusPrivacy(entity,user.uid);
  }
}
