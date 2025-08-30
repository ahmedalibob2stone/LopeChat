
import '../../../datasource/account/security/security_local_datasorce.dart';

abstract class SecuritySettingsRepository {
  Future<bool> isSecurityNotificationEnabled();
  Future<void> updateSecurityNotificationStatus(bool enabled);
  Future<void> disableSecurityNotifications();
}

class SecuritySettingsRepositoryImpl implements SecuritySettingsRepository {
  final SecuritySettingsLocalDataSource localDataSource;

  SecuritySettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> isSecurityNotificationEnabled() {
    return localDataSource.getSecurityNotificationStatus();
  }

  @override
  Future<void> updateSecurityNotificationStatus(bool enabled) {
    return localDataSource.setSecurityNotificationStatus(enabled);
  }

  @override
  Future<void> disableSecurityNotifications() {
    return localDataSource.disableSecurityNotifications();
  }
}
