

import '../../../../domain/repository/privacy/app lock/app_lock_repository.dart';
import '../../../datasource/privacy/app lock/app_lock_local_datasource.dart';

class AppLockRepositoryImpl implements AppLockRepository {
  final AppLockLocalDataSource localDataSource;

  AppLockRepositoryImpl(this.localDataSource);

  @override
  Future<void> enableAppLock(bool enabled) =>
      localDataSource.setAppLockEnabled(enabled);

  @override
  Future<bool> isAppLockEnabled() => localDataSource.isAppLockEnabled();

  @override
  Future<void> setAutoLockOption(int option) =>
      localDataSource.setAutoLockOption(option);

  @override
  Future<int> getAutoLockOption() => localDataSource.getAutoLockOption();

  @override
  Future<void> savePassword(String password) =>
      localDataSource.setLockPassword(password);

  @override
  Future<String?> getSavedPassword() =>
      localDataSource.getLockPassword();

  @override
  Future<void> clearAppLockData() => localDataSource.clearAppLock();

  @override
  Future<bool> authenticateWithBiometrics() => localDataSource.authenticateWithBiometrics();

}
