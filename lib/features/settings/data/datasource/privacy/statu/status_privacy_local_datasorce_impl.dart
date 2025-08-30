import 'dart:convert';
import 'package:lopechat/features/settings/data/datasource/privacy/statu/status_privacy_local_datasorce.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/privacy/statu/status_privacy_model.dart';

class StatusPrivacyLocalDataSourceImpl implements StatusPrivacyLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const _keyPrefix = 'status_privacy_';

  StatusPrivacyLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<StatusPrivacyModel?> getStatusPrivacy(String userId) async {
    final jsonString = sharedPreferences.getString('$_keyPrefix$userId');
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return StatusPrivacyModel.fromMap(jsonMap);
  }

  @override
  Future<void> saveStatusPrivacy(String userId, StatusPrivacyModel statusPrivacy) async {
    final jsonString = json.encode(statusPrivacy.toMap());
    await sharedPreferences.setString('$_keyPrefix$userId', jsonString);
  }
}
