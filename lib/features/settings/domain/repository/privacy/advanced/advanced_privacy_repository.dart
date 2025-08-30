import '../../../entities/privacy/advanced/advanced_privacy_entity.dart';

abstract class AdvancedPrivacyRepository {
  Future<void> setBlockUnknownSenders(String uid, bool value);
  Future<AdvancedPrivacyEntity> getBlockUnknownSenders(String uid);

  Future<void> setProtectIpInCalls(bool value);
  Future<bool> getProtectIpInCalls();

  Future<void> setDisableLinkPreviews(bool value);
  Future<bool> getDisableLinkPreviews();
}
