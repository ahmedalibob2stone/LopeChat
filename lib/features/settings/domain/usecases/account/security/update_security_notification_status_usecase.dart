
import '../../../../data/repository/account/security/security_repository_impl.dart';

class UpdateSecurityNotificationStatusUseCase {
  final SecuritySettingsRepository repository;

  UpdateSecurityNotificationStatusUseCase(this.repository);

  Future<void> call(bool enabled) {
    return repository.updateSecurityNotificationStatus(enabled);
  }
}
