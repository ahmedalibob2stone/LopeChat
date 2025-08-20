import '../../../entities/privacy/links/links_privacy_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../repository/privacy/links/links_privacy_repository.dart';

class UpdateLinksPrivacyUseCase {
  final LinksPrivacyRepository repository;
  final FirebaseAuth auth;

  UpdateLinksPrivacyUseCase({
    required this.repository,
    required this.auth,
  });

  Future<void> call(LinksPrivacyEntity entity) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    await repository.setLinksPrivacy(uid, entity);
  }
}
