import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/datasource/account/report/report_settings_remote_datasorce.dart';
import '../../../../../data/repository/account/report/report_settings_repository_impl.dart';
import '../../../../../domain/repository/account/report/report_settings_repository.dart';

final reportSettingsRemoteDataSourceProvider = Provider<ReportSettingsRemoteDataSource>((ref) {
  return ReportSettingsRemoteDataSource();
});
final reportSettingsRepositoryProvider = Provider<ReportSettingsRepository>((ref) {
  final remoteDataSource = ref.read(reportSettingsRemoteDataSourceProvider);
  return ReportSettingsRepositoryImpl(remoteDataSource);
});
