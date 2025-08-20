import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/privacy/calls/privacy_calls_viewmodel.dart';
import '../usecases/get_privacy_calls_usecases_provider.dart';

final privacyCallsViewModelProvider = StateNotifierProvider<PrivacyCallsViewModel, PrivacyCallsState>(
      (ref) => PrivacyCallsViewModel(
    getUseCase: ref.read(getPrivacyCallsUseCaseProvider),
    updateUseCase: ref.read(updatePrivacyCallsUseCaseProvider),
  ),
);
