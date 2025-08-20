import 'package:flutter_secure_storage/flutter_secure_storage.dart';
abstract class AppLockLocalDataSource {
  Future<void> setAppLockEnabled(bool value);
  Future<bool> isAppLockEnabled();

  Future<void> setAutoLockOption(int option);
  Future<int> getAutoLockOption();

  Future<void> setLockPassword(String password);
  Future<String?> getLockPassword();

  Future<void> clearAppLock();
  Future<bool> authenticateWithBiometrics(); // ✔ هنا مهم

}

