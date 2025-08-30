import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/privacy/app lock/app_lock_viewmodel.dart';
import '../usecases/provider.dart';

final appLockViewModelProvider =
StateNotifierProvider<AppLockViewModel, AppLockState>((ref) {
  return AppLockViewModel(
    enableAppLock: ref.read(enableAppLockUseCaseProvider),
    isAppLockEnabled: ref.read(isAppLockEnabledUseCaseProvider),
    savePassword: ref.read(saveLockPasswordUseCaseProvider),
    getPassword: ref.read(getLockPasswordUseCaseProvider),
    setAutoLockOption: ref.read(setAutoLockOptionUseCaseProvider),
    getAutoLockOption: ref.read(getAutoLockOptionUseCaseProvider),
    clearAppLock: ref.read(clearAppLockUseCaseProvider),
    biometricAuth: ref.read(authenticateWithBiometricsUseCaseProvider),
  );
});
