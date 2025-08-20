import 'package:shared_preferences/shared_preferences.dart';

abstract class EmailLocalDataSource {
  /// جلب البريد الإلكتروني المحفوظ، يعيد null إذا لم يكن موجود
  Future<String?> getEmail();

  /// حفظ البريد الإلكتروني
  Future<void> setEmail(String email);

  /// حذف البريد الإلكتروني (اختياري، إذا تريد تفعيل خاصية حذف البريد)
  Future<void> clearEmail();
}

class EmailLocalDataSourceImpl implements EmailLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const _keyEmail = 'user_email';

  EmailLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<String?> getEmail() async {
    return sharedPreferences.getString(_keyEmail);
  }

  @override
  Future<void> setEmail(String email) async {
    await sharedPreferences.setString(_keyEmail, email);
  }

  @override
  Future<void> clearEmail() async {
    await sharedPreferences.remove(_keyEmail);
  }
}
