import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/acount/security/security_viewmodel.dart';
import '../usecases/provider.dart';

final securitySettingsViewModelProvider =
StateNotifierProvider<SecuritySettingsViewModel, SecuritySettingsState>((ref) {
  final getStatusUseCase = ref.watch(getSecurityNotificationStatusUseCaseProvider);
  final updateStatusUseCase = ref.watch(updateSecurityNotificationStatusUseCaseProvider);

  return SecuritySettingsViewModel(
    getStatusUseCase: getStatusUseCase,
    updateStatusUseCase: updateStatusUseCase,
  );
});
