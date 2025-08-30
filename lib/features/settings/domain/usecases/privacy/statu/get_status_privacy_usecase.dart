import 'package:firebase_auth/firebase_auth.dart';

import '../../../entities/privacy/statu/statu_privacy_entity.dart';
import '../../../repository/privacy/statu/status_privacy_repository.dart';

class GetStatusPrivacyUseCase {
  final StatusPrivacyRepository repository;
  final FirebaseAuth auth;

  GetStatusPrivacyUseCase({
    required this.repository,
    required this.auth,
  });

  Future<StatusPrivacyEntity?> call() async {
    final user = auth.currentUser;
    if (user == null) return null;

    return await repository.getStatusPrivacy(user.uid);
  }
}
