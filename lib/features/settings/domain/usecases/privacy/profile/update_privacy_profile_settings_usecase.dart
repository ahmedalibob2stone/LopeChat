import 'package:firebase_auth/firebase_auth.dart';

import '../../../entities/privacy/privacy_profile/privacy_profile_entity.dart';
import '../../../repository/privacy/profile/privacy_profile_repository.dart';

class UpdateProfilePrivacyUseCase {
  final ProfilePrivacyRepository repository;
  final FirebaseAuth auth;

  UpdateProfilePrivacyUseCase(this.repository, this.auth);

  Future<void> call(ProfileEntity entity) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    await repository.updateProfilePrivacy(uid, entity);
  }
}
