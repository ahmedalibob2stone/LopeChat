
import 'package:firebase_auth/firebase_auth.dart';

import '../../../entities/privacy/links/links_privacy_entity.dart';
import '../../../repository/privacy/links/links_privacy_repository.dart';

class GetLinksPrivacyUseCase {
  final LinksPrivacyRepository repository;
  final FirebaseAuth auth;

  GetLinksPrivacyUseCase({
    required this.repository,
    required this.auth,
  });

  Future<LinksPrivacyEntity?> call() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return await repository.getLinksPrivacy(uid);
  }
}
