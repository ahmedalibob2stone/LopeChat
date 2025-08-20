import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/usecases/account/security/disable_Security_notifications_usecase.dart';
import '../../../../../domain/usecases/account/security/get_security_notification_status-usecase.dart';
import '../../../../../domain/usecases/account/security/update_security_notification_status_usecase.dart';
import '../data/provider.dart';

final getSecurityNotificationStatusUseCaseProvider = Provider<GetSecurityNotificationStatusUseCase>(
      (ref) {
    final repository = ref.watch(securitySettingsRepositoryProvider);
    return GetSecurityNotificationStatusUseCase(repository);
  },
);

final updateSecurityNotificationStatusUseCaseProvider = Provider<UpdateSecurityNotificationStatusUseCase>(
      (ref) {
    final repository = ref.watch(securitySettingsRepositoryProvider);
    return UpdateSecurityNotificationStatusUseCase(repository);
  },
);

final disableSecurityNotificationsUseCaseProvider = Provider<DisableSecurityNotificationsUseCase>(
      (ref) {
    final repository = ref.watch(securitySettingsRepositoryProvider);
    return DisableSecurityNotificationsUseCase(repository);
  },
);
