

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/privacy/links/privacy_links_viewmodel.dart';
import '../usecase/provider.dart';

final linksPrivacyViewModelProvider =
StateNotifierProvider<LinksPrivacyViewModel, LinksPrivacyState>((ref) {
  final getUseCase = ref.watch(getLinksPrivacyUseCaseProvider);
  final updateUseCase = ref.watch(updateLinksPrivacyUseCaseProvider);

  return LinksPrivacyViewModel(
    getUseCase: getUseCase,
    setUseCase: updateUseCase,
  );
});
