import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/datasource/privacy/app lock/app_lock_local_datasource.dart';
import '../../../../../data/datasource/privacy/app lock/app_lock_local_datasource_Impl.dart';
import '../../../../../data/repository/privacy/app lock/app_lock_repository.dart';
import '../../../../../domain/repository/privacy/app lock/app_lock_repository.dart';

final appLockLocalDataSourceProvider = Provider<AppLockLocalDataSource>((ref) {
  return AppLockLocalDataSourceImpl();
});
final appLockRepositoryProvider = Provider<AppLockRepository>((ref) {
  final dataSource = ref.read(appLockLocalDataSourceProvider);
  return AppLockRepositoryImpl(dataSource);
});