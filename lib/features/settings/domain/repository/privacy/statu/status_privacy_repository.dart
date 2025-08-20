import '../../../entities/privacy/statu/statu_privacy_entity.dart';

abstract class StatusPrivacyRepository {
  Future<StatusPrivacyEntity> getStatusPrivacy(String userId);
  Future<void> saveStatusPrivacy(StatusPrivacyEntity privacy,String userId);
}
