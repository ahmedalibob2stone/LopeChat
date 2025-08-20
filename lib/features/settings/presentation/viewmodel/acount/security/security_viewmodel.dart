import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/usecases/account/security/get_security_notification_status-usecase.dart';
import '../../../../domain/usecases/account/security/update_security_notification_status_usecase.dart';

enum SecurityNotificationStatus { initial, loading, enabled, disabled, error }

class SecuritySettingsState {
  final SecurityNotificationStatus status;
  final bool isEnabled;
  final String? errorMessage;

  SecuritySettingsState({
    this.status = SecurityNotificationStatus.initial,
    this.isEnabled = true,
    this.errorMessage,
  });

  SecuritySettingsState copyWith({
    SecurityNotificationStatus? status,
    bool? isEnabled,
    String? errorMessage,
  }) {
    return SecuritySettingsState(
      status: status ?? this.status,
      isEnabled: isEnabled ?? this.isEnabled,
      errorMessage: errorMessage,
    );
  }
}

class SecuritySettingsViewModel extends StateNotifier<SecuritySettingsState> {
  final GetSecurityNotificationStatusUseCase _getStatusUseCase;
  final UpdateSecurityNotificationStatusUseCase _updateStatusUseCase;

  SecuritySettingsViewModel({
    required GetSecurityNotificationStatusUseCase getStatusUseCase,
    required UpdateSecurityNotificationStatusUseCase updateStatusUseCase,
  })  : _getStatusUseCase = getStatusUseCase,
        _updateStatusUseCase = updateStatusUseCase,
        super(SecuritySettingsState()) {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    state = state.copyWith(status: SecurityNotificationStatus.loading);
    try {
      final enabled = await _getStatusUseCase();
      state = state.copyWith(
        status: enabled
            ? SecurityNotificationStatus.enabled
            : SecurityNotificationStatus.disabled,
        isEnabled: enabled,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: SecurityNotificationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> toggleNotification(bool enabled) async {
    state = state.copyWith(status: SecurityNotificationStatus.loading);
    try {
      await _updateStatusUseCase(enabled);
      state = state.copyWith(
        status: enabled
            ? SecurityNotificationStatus.enabled
            : SecurityNotificationStatus.disabled,
        isEnabled: enabled,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: SecurityNotificationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
