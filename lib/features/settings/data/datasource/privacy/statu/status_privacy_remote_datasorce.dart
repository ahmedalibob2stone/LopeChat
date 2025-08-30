import '../../../model/privacy/statu/status_privacy_model.dart';

abstract class StatusPrivacyRemoteDataSource {
  Future<StatusPrivacyModel?> getStatusPrivacy({required String userId});
  Future<void> saveStatusPrivacy({required StatusPrivacyModel statusPrivacy,required String userId, });
}

