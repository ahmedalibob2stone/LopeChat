import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasource/report/report_remote_datasource.dart';
import '../../../../data/repository/report/report_repository_impl.dart';
import '../../../../domain/repository/report/report_repository.dart';



final reportRemoteDataSourceProvider = Provider<ReportRemoteDataSource>((ref) {
  return ReportRemoteDataSource();
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final remoteDataSource = ref.read(reportRemoteDataSourceProvider);
  return ReportRepositoryImpl(remoteDataSource: remoteDataSource);
});
