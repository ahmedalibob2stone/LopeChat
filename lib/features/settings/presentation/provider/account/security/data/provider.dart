import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../main.dart';
import '../../../../../data/datasource/account/security/security_local_datasorce.dart';
import '../../../../../data/repository/account/security/security_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../privacy/advanced/usecases/get_disable_link_previews_usecase_provider.dart';


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


