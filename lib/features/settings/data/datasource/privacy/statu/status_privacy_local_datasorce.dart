import '../../../model/privacy/statu/status_privacy_model.dart';

abstract class StatusPrivacyLocalDataSource {
  Future<StatusPrivacyModel?> getStatusPrivacy(String userId);
  Future<void> saveStatusPrivacy(String userId, StatusPrivacyModel statusPrivacy);
}
