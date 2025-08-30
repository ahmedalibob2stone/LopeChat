import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/privacy/about/privacy_about_viewmodel.dart';
import '../usecases/provider.dart';

final aboutPrivacyViewModelProvider =
StateNotifierProvider<AboutPrivacyViewModel, AboutPrivacyState>((ref) {
  final getUseCase = ref.watch(getAboutPrivacyUseCaseProvider);
  final updateUseCase = ref.watch(updateAboutPrivacyUseCaseProvider);

  return AboutPrivacyViewModel(
    getUseCase: getUseCase,
    updateUseCase: updateUseCase,
  );
});