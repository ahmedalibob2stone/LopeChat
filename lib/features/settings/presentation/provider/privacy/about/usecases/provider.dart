import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/usecases/privacy/about/get_about_privacy_usecase.dart';
import '../../../../../domain/usecases/privacy/about/update_about_privacy_usecase.dart';
import '../data/provider.dart';

final getAboutPrivacyUseCaseProvider = Provider<GetAboutPrivacyUseCase>((ref) {
  final repository = ref.watch(privacyAboutRepositoryProvider);
  return GetAboutPrivacyUseCase(repository);
});
final updateAboutPrivacyUseCaseProvider = Provider<UpdateAboutPrivacyUseCase>((ref) {
  final repository = ref.watch(privacyAboutRepositoryProvider);
  return UpdateAboutPrivacyUseCase(repository);
});
