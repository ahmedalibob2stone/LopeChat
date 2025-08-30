import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecases/privacy/app lock/authenticate_with_biometrics_usecase.dart';
import '../../../../domain/usecases/privacy/app lock/clear_app_lock_usecase.dart';
import '../../../../domain/usecases/privacy/app lock/enable_app_lock_usecase.dart';
import '../../../../domain/usecases/privacy/app lock/get_auto_lock_option_usecase.dart';
import '../../../../domain/usecases/privacy/app lock/get_lock_password_usecase.dart';
import '../../../../domain/usecases/privacy/app lock/is_app_lock_enabled_usecase.dart';
import '../../../../domain/usecases/privacy/app lock/save_lock_password_usecase.dart';
import '../../../../domain/usecases/privacy/app lock/set_auto_lock_option_usecase.dart';
class AppLockState {
  final bool isAppLockEnabled;
  final String? password;
  final int autoLockOption;
  final bool authFailed;


  AppLockState({
    this.isAppLockEnabled = false,
    this.password,
    this.autoLockOption = 0,
  this.authFailed = false
  });

  AppLockState copyWith({
    bool? isAppLockEnabled,
    String? password,
    int? autoLockOption,
    bool? authFailed
  }) {
    return AppLockState(
      isAppLockEnabled: isAppLockEnabled ?? this.isAppLockEnabled,
      password: password ?? this.password,
      autoLockOption: autoLockOption ?? this.autoLockOption,
        authFailed: authFailed ?? this.authFailed
    );
  }
}

class AppLockViewModel extends StateNotifier<AppLockState> {
  final EnableAppLockUseCase enableAppLock;
  final IsAppLockEnabledUseCase isAppLockEnabled;
  final SaveLockPasswordUseCase savePassword;
  final GetLockPasswordUseCase getPassword;
  final SetAutoLockOptionUseCase setAutoLockOption;
  final GetAutoLockOptionUseCase getAutoLockOption;
  final ClearAppLockUseCase clearAppLock;
    final AuthenticateWithBiometricsUseCase biometricAuth;

  AppLockViewModel({
    required this.enableAppLock,
    required this.isAppLockEnabled,
    required this.savePassword,
    required this.getPassword,
    required this.setAutoLockOption,
    required this.getAutoLockOption,
    required this.clearAppLock,
    required this.biometricAuth,
  }) : super(AppLockState());

  Future<void> loadAppLockData() async {
    try {
      final enabled = await isAppLockEnabled();
      final password = await getPassword();
      final option = await getAutoLockOption();

      state = state.copyWith(
        isAppLockEnabled: enabled,
        password: password,
        autoLockOption: option,
      );
    } catch (e) {
    }
  }

  Future<void> updateAppLock(bool enable) async {
    try {
      await enableAppLock(enable);
      state = state.copyWith(isAppLockEnabled: enable);
    } catch (e) {
    }
  }

  Future<void> saveLockPassword(String password) async {
    try {
      await savePassword(password);
      state = state.copyWith(password: password);
    } catch (e) {
    }
  }

  Future<void> setAutoLock(int option) async {
    try {
      await setAutoLockOption(option);
      state = state.copyWith(autoLockOption: option);
    } catch (e) {
    }
  }

  Future<void> clearAppLockData() async {
    try {
      await clearAppLock();
      state = AppLockState();
    } catch (e) {
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await biometricAuth();
    } catch (_) {
      return false;
    }
  }
  Future<bool> tryBiometricAuth() async {
    final success = await biometricAuth();
    state = state.copyWith(authFailed: !success);
    return success;
  }

  void resetAuthError() {
    state = state.copyWith(authFailed: false);
  }
}
