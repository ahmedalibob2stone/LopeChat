

import '../../../repository/privacy/advanced/advanced_privacy_repository.dart';

class SetDisableLinkPreviewsUseCase {
  final AdvancedPrivacyRepository repository;

  SetDisableLinkPreviewsUseCase({required this.repository});

  Future<void> call(bool value) {
    return repository.setDisableLinkPreviews(value);
  }
}
