
import '../../../entities/privacy/privacy_profile/privacy_profile_entity.dart';


abstract class ProfilePrivacyRepository {
  Future<ProfileEntity> getProfilePrivacy(String userId);
  Future<void> updateProfilePrivacy(String userId, ProfileEntity model);
}

