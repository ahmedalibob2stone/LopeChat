import 'package:shared_preferences/shared_preferences.dart';

import 'advanced_privacy_datasource.dart';



class AdvancedPrivacyLocalDatasourceImpl implements AdvancedPrivacyLocalDatasource {
  static const _protectIpInCallsKey = 'protectIpInCalls';
  static const _disableLinkPreviewsKey = 'disableLinkPreviews';

  final SharedPreferences sharedPreferences;

  AdvancedPrivacyLocalDatasourceImpl(this.sharedPreferences,  );



  @override
  Future<void> setProtectIpInCalls(bool value) async {
    await sharedPreferences.setBool(_protectIpInCallsKey, value);
  }

  @override
  Future<bool> getProtectIpInCalls() async {
    return sharedPreferences.getBool(_protectIpInCallsKey) ?? false;
  }

  @override
  Future<void> setDisableLinkPreviews(bool value) async {
    await sharedPreferences.setBool(_disableLinkPreviewsKey, value);
  }

  @override
  Future<bool> getDisableLinkPreviews() async {
    return sharedPreferences.getBool(_disableLinkPreviewsKey) ?? false;
  }
}
