import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/acount/report/report_viewmodel.dart';
import '../usecases/provider.dart';

final reportSettingsViewModelProvider = StateNotifierProvider<ReportSettingsViewModel, ReportSettingsState>(
      (ref) {
    final getUseCase = ref.watch(getReportSettingsUseCaseProvider);
    final setUseCase = ref.watch(setReportSettingsUseCaseProvider);
    final updateAccountUseCase = ref.watch(updateAutoAccountReportUseCaseProvider);
    final updateChannelUseCase = ref.watch(updateAutoChannelReportUseCaseProvider);

    return ReportSettingsViewModel(getUseCase, setUseCase, updateAccountUseCase, updateChannelUseCase);
  },
);
