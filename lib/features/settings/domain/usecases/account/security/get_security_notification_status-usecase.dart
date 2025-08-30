
import '../../../../data/repository/account/security/security_repository_impl.dart';

class GetSecurityNotificationStatusUseCase {
  final SecuritySettingsRepository repository;

  GetSecurityNotificationStatusUseCase(this.repository);

  Future<bool> call() {
    return repository.isSecurityNotificationEnabled();
  }
}
