import 'dart:convert';

import '../../../model/privacy/last seen and online/last_seen_online_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LastSeenAndOnlineLocalDataSource {
  Future<void> cacheLastSeenAndOnlineSettings(LastSeenAndOnlineModel model);
  Future<LastSeenAndOnlineModel?> getCachedLastSeenAndOnlineSettings();
}


class LastSeenAndOnlineLocalDataSourceImpl implements LastSeenAndOnlineLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _cachedKey = 'cached_last_seen_and_online';

  LastSeenAndOnlineLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheLastSeenAndOnlineSettings(LastSeenAndOnlineModel model) async {
    final jsonString = json.encode(model.toMap());
    await sharedPreferences.setString(_cachedKey, jsonString);
  }

  @override
  Future<LastSeenAndOnlineModel?> getCachedLastSeenAndOnlineSettings() async {
    final jsonString = sharedPreferences.getString(_cachedKey);
    if (jsonString != null) {
      final Map<String, dynamic> map = json.decode(jsonString);
      return LastSeenAndOnlineModel.fromMap(map);
    }
    return null;
  }
}
