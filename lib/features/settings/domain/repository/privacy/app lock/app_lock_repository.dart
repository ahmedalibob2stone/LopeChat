abstract class AppLockRepository {
  Future<void> enableAppLock(bool enabled);
  Future<bool> isAppLockEnabled();

  Future<void> setAutoLockOption(int option);
  Future<int> getAutoLockOption();

  Future<void> savePassword(String password);
  Future<String?> getSavedPassword();

  Future<void> clearAppLockData();

  Future<bool> authenticateWithBiometrics() ;

}
