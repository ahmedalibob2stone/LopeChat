import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/report/report_entities.dart';
import '../../../../domain/usecase/report/get_my_report_usecase.dart';
import '../../../../domain/usecase/report/report_use_usecase.dart';
import '../data/provider.dart';

final reportUserUseCaseProvider = Provider<ReportUserUseCase>((ref) {
  final repository = ref.read(reportRepositoryProvider);
  return ReportUserUseCase(repository);
});

final getMyReportsUseCaseProvider = Provider<GetMyReportsUseCase>((ref) {
  final repository = ref.read(reportRepositoryProvider);
  return GetMyReportsUseCase(repository);
});
