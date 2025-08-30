import '../../../model/privacy/advanced/advanced_privacy_model.dart';

abstract class AdvancedPrivacyLocalDatasource {
  Future<void> setProtectIpInCalls(bool value);
  Future<bool> getProtectIpInCalls();

  Future<void> setDisableLinkPreviews(bool value);
  Future<bool> getDisableLinkPreviews();
}

abstract class AdvancedPrivacyRemoteDataSource {

  Future<void> setBlockUnknownSenders({required String uid, required bool value,});
  Future<AdvancedPrivacyModel> getBlockUnknownSenders(String uid);

}

