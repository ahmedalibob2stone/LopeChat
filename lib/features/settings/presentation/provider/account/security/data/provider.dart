import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/datasource/account/security/security_local_datasorce.dart';
import '../../../../../data/repository/account/security/security_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';


final securitySettingsLocalDataSourceProvider = Provider<SecuritySettingsLocalDataSource>(
      (ref) {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    return SecuritySettingsLocalDataSourceImpl(sharedPreferences);
  },
);

final securitySettingsRepositoryProvider = Provider<SecuritySettingsRepository>(
      (ref) {
    final localDataSource = ref.watch(securitySettingsLocalDataSourceProvider);
    return SecuritySettingsRepositoryImpl(localDataSource: localDataSource);
  },
);


final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // سيتم تهيئته في main()
});
