import 'package:firebase_auth/firebase_auth.dart';

import '../../../entities/privacy/privacy_profile/privacy_profile_entity.dart';
import '../../../repository/privacy/profile/privacy_profile_repository.dart';

class GetProfilePrivacyUseCase {
  final ProfilePrivacyRepository repository;
  final FirebaseAuth auth;

  GetProfilePrivacyUseCase(this.repository, this.auth);

  Future<ProfileEntity> call() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    return await repository.getProfilePrivacy(uid);
  }
}
