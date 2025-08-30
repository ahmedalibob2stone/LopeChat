import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/datasource/account/account manage/local_auth_data_source.dart dart.dart';
import '../../../../../data/repository/account/account manage/auth_local_repository_impl.dart';

final localAuthDataSourceProvider = Provider<LocalAuthDataSource>((ref) {
  return LocalAuthDataSource(); // إنشاؤه مسبقًا
});

final authLocalRepositoryProvider = Provider<AuthLocalRepositoryImpl>((ref) {
  return AuthLocalRepositoryImpl(ref.watch(localAuthDataSourceProvider));
});