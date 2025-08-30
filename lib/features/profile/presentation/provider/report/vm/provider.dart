import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodel/report/report_viewmodel.dart';
import '../usecases/provider.dart';

final reportViewModelProvider = StateNotifierProvider<ReportViewModel, ReportState>((ref) {
  final reportUserUseCase = ref.watch(reportUserUseCaseProvider);
  return ReportViewModel(reportUserUseCase: reportUserUseCase);
});
