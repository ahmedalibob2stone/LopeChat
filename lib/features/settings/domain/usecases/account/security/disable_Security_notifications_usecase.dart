
import '../../../../data/repository/account/security/security_repository_impl.dart';

class DisableSecurityNotificationsUseCase {
  final SecuritySettingsRepository repository;

  DisableSecurityNotificationsUseCase(this.repository);

  Future<void> call() {
    return repository.disableSecurityNotifications();
  }
}
