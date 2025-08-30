import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/usecases/privacy/app lock/authenticate_with_biometrics_usecase.dart';
import '../../../../../domain/usecases/privacy/app lock/clear_app_lock_usecase.dart';
import '../../../../../domain/usecases/privacy/app lock/enable_app_lock_usecase.dart';
import '../../../../../domain/usecases/privacy/app lock/get_auto_lock_option_usecase.dart';
import '../../../../../domain/usecases/privacy/app lock/get_lock_password_usecase.dart';
import '../../../../../domain/usecases/privacy/app lock/is_app_lock_enabled_usecase.dart';
import '../../../../../domain/usecases/privacy/app lock/save_lock_password_usecase.dart';
import '../../../../../domain/usecases/privacy/app lock/set_auto_lock_option_usecase.dart';
import '../data/provider.dart';

final authenticateWithBiometricsUseCaseProvider = Provider(
      (ref) => AuthenticateWithBiometricsUseCase(ref.read(appLockRepositoryProvider)),
);

final clearAppLockUseCaseProvider = Provider(
      (ref) => ClearAppLockUseCase(ref.read(appLockRepositoryProvider)),
);

final enableAppLockUseCaseProvider = Provider(
      (ref) => EnableAppLockUseCase(ref.read(appLockRepositoryProvider)),
);

final getAutoLockOptionUseCaseProvider = Provider(
      (ref) => GetAutoLockOptionUseCase(ref.read(appLockRepositoryProvider)),
);

final getLockPasswordUseCaseProvider = Provider(
      (ref) => GetLockPasswordUseCase(ref.read(appLockRepositoryProvider)),
);

final isAppLockEnabledUseCaseProvider = Provider(
      (ref) => IsAppLockEnabledUseCase(ref.read(appLockRepositoryProvider)),
);

final setAutoLockOptionUseCaseProvider = Provider(
      (ref) => SetAutoLockOptionUseCase(ref.read(appLockRepositoryProvider)),
);

final saveLockPasswordUseCaseProvider = Provider(
      (ref) => SaveLockPasswordUseCase(ref.read(appLockRepositoryProvider)),
);
