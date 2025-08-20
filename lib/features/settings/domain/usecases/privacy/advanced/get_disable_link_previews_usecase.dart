

import '../../../repository/privacy/advanced/advanced_privacy_repository.dart';

class GetDisableLinkPreviewsUseCase {
  final AdvancedPrivacyRepository repository;

  GetDisableLinkPreviewsUseCase({required this.repository});

  Future<bool> call() {
    return repository.getDisableLinkPreviews();
  }
}
