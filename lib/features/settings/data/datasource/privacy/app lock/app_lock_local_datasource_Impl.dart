import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import 'app_lock_local_datasource.dart';

class AppLockLocalDataSourceImpl implements AppLockLocalDataSource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final LocalAuthentication _auth = LocalAuthentication();


  static const _keyAppLockEnabled = 'app_lock_enabled';
  static const _keyAutoLockOption = 'auto_lock_option';
  static const _keyLockPassword = 'app_lock_password';

  Future<void> setAppLockEnabled(bool value) async {
    await _storage.write(key: _keyAppLockEnabled, value: value.toString());
  }

  Future<bool> isAppLockEnabled() async {
    final result = await _storage.read(key: _keyAppLockEnabled);
    return result == 'true';
  }

  Future<void> setAutoLockOption(int option) async {
    await _storage.write(key: _keyAutoLockOption, value: option.toString());
  }

  Future<int> getAutoLockOption() async {
    final result = await _storage.read(key: _keyAutoLockOption);
    return int.tryParse(result ?? '') ?? 0;
  }

  Future<void> setLockPassword(String password) async {
    await _storage.write(key: _keyLockPassword, value: password);
  }

  Future<String?> getLockPassword() async {
    return await _storage.read(key: _keyLockPassword);
  }

  Future<void> clearAppLock() async {
    await _storage.delete(key: _keyAppLockEnabled);
    await _storage.delete(key: _keyAutoLockOption);
    await _storage.delete(key: _keyLockPassword);
  }
  @override
  Future<bool> authenticateWithBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();

      if (!canCheck || !isDeviceSupported) return false;

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
