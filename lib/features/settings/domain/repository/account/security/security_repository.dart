abstract class SecuritySettingsRepository {
  /// استرجاع حالة تفعيل إشعارات الأمان
  Future<bool> isSecurityNotificationEnabled();

  /// تحديث حالة إشعارات الأمان (تفعيل/تعطيل)
  Future<void> updateSecurityNotificationStatus(bool enabled);

  /// إلغاء إشعارات الأمان (اختياري)
  Future<void> disableSecurityNotifications();
}
