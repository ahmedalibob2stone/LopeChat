import 'package:shared_preferences/shared_preferences.dart';
import 'camera_effect_datasource.dart';

class CameraEffectsDataSourceImpl implements CameraEffectsDataSource {
  final SharedPreferences sharedPreferences;
  static const String _key = 'camera_effects_enabled';

  CameraEffectsDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> getEffectsStatus() async {
    return sharedPreferences.getBool(_key) ?? false;
  }

  @override
  Future<void> setEffectsStatus(bool isEnabled) async {
    await sharedPreferences.setBool(_key, isEnabled);
  }


}
