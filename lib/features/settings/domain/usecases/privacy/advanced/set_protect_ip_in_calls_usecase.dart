
import '../../../repository/privacy/advanced/advanced_privacy_repository.dart';

class SetProtectIpInCallsUseCase {
  final AdvancedPrivacyRepository repository;

  SetProtectIpInCallsUseCase({required this.repository});

  Future<void> call(bool value) {
    return repository.setProtectIpInCalls(value);
  }
}
