import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../model/privacy/links/model/links_privacy_model.dart';

abstract class LinksPrivacyLocalDataSource {
  Future<void> cacheLinksPrivacy(LinksPrivacyModel model);
  Future<LinksPrivacyModel?> getCachedLinksPrivacy();
  Future<void> clearCache();
}

class LinksPrivacyLocalDataSourceImpl implements LinksPrivacyLocalDataSource {
  final SharedPreferences prefs;
  static const _cacheKey = 'links_privacy_cache';

  LinksPrivacyLocalDataSourceImpl(this.prefs);

  @override
  Future<void> cacheLinksPrivacy(LinksPrivacyModel model) async {
    final jsonString = jsonEncode(model.toMap());
    await prefs.setString(_cacheKey, jsonString);
  }

  @override
  Future<LinksPrivacyModel?> getCachedLinksPrivacy() async {
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> map = jsonDecode(jsonString);
    return LinksPrivacyModel.fromMap(map);
  }

  @override
  Future<void> clearCache() async {
    await prefs.remove(_cacheKey);
  }
}
