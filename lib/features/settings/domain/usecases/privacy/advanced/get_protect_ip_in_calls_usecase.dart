

import '../../../repository/privacy/advanced/advanced_privacy_repository.dart';

class GetProtectIpInCallsUseCase {
  final AdvancedPrivacyRepository repository;

  GetProtectIpInCallsUseCase({required this.repository});

  Future<bool> call() {
    return repository.getProtectIpInCalls();
  }
}
