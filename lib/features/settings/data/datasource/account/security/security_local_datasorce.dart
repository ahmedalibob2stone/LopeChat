import 'package:shared_preferences/shared_preferences.dart';

abstract class SecuritySettingsLocalDataSource {
  /// قراءة حالة تفعيل إشعارات الأمان
  Future<bool> getSecurityNotificationStatus();

  /// تفعيل أو إلغاء تفعيل إشعارات الأمان
  Future<void> setSecurityNotificationStatus(bool enabled);

  /// إلغاء إشعارات الأمان (اختياري، يمكن تنفيذها بنفس setSecurityNotificationStatus(false))
  Future<void> disableSecurityNotifications();
}

class SecuritySettingsLocalDataSourceImpl implements SecuritySettingsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const _keySecurityNotifications = 'security_notifications_enabled';

  SecuritySettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> getSecurityNotificationStatus() async {
    return sharedPreferences.getBool(_keySecurityNotifications) ?? true; // القيمة الافتراضية true
  }

  @override
  Future<void> setSecurityNotificationStatus(bool enabled) async {
    await sharedPreferences.setBool(_keySecurityNotifications, enabled);
  }

  @override
  Future<void> disableSecurityNotifications() async {
    await setSecurityNotificationStatus(false);
  }
}
