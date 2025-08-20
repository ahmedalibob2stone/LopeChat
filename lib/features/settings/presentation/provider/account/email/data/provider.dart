import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../data/datasource/account/email/email_local_datasorce.dart';
import '../../../../../domain/repository/account/email/email_repository.dart';

final emailRepositoryProvider = Provider<EmailRepository>((ref) {
  throw UnimplementedError();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // يتم تهيئته في main
});

final emailLocalDataSourceProvider = Provider<EmailLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return EmailLocalDataSourceImpl(sharedPreferences);
});
