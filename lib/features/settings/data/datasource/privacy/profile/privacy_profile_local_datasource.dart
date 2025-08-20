import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/privacy/privacy_profile/privacy_profile_model.dart';

abstract class ProfilePrivacyLocalDataSource {
  Future<void> cacheProfilePrivacy(ProfileModel model);
  Future<ProfileModel?> getCachedProfilePrivacy();
}


class ProfilePrivacyLocalDataSourceImpl implements ProfilePrivacyLocalDataSource {
  static const _cachedKey = 'cached_profile_privacy';

  @override
  Future<void> cacheProfilePrivacy(ProfileModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toMap());
    await prefs.setString(_cachedKey, jsonString);
  }

  @override
  Future<ProfileModel?> getCachedProfilePrivacy() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cachedKey);

    if (jsonString == null) return null;

    final Map<String, dynamic> map = jsonDecode(jsonString);
    return ProfileModel.fromMap(map);
  }
}
