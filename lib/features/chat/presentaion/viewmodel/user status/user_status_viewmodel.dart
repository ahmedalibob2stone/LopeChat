import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/user status/get_user_last_seen_usecase.dart';
import '../../../domain/usecase/user status/get_user_online_status_usecase.dart';
import '../../../domain/usecase/user status/update_user_status_usecase.dart';

class UserStatusState {
  final bool isOnline;
  final String? lastSeen;
  final bool isLoading;
  final String? error;

  const UserStatusState({
    this.isOnline = false,
    this.lastSeen,
    this.isLoading = false,
    this.error,
  });

  UserStatusState copyWith({
    bool? isOnline,
    String? lastSeen,
    bool? isLoading,
    String? error,
  }) {
    return UserStatusState(
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserStatusViewModel extends StateNotifier<UserStatusState> {
  final UpdateUserusUseCase updateStatusUseCase;
  final GetUserLastSeenUseCase getLastSeenUseCase;
  final GetUserOnlineStatusUseCase getOnlineStatusUseCase;

  UserStatusViewModel({
    required this.updateStatusUseCase,
    required this.getLastSeenUseCase,
    required this.getOnlineStatusUseCase,
  }) : super(const UserStatusState());

  /// تحديث حالة المستخدم (اونلاين / اوفلاين)
  Future<void> updateStatus(bool isOnline) async {
    try {
      state = state.copyWith(isLoading: true);
      await updateStatusUseCase(isOnline: isOnline);
      state = state.copyWith(isOnline: isOnline, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// تحميل اخر ظهور للمستخدم
  Future<void> loadLastSeen(String userId) async {
    try {
      state = state.copyWith(isLoading: true);
      final lastSeen = await getLastSeenUseCase(userId);
      state = state.copyWith(lastSeen: lastSeen, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// تحميل حالة الاتصال اونلاين/اوفلاين
  Future<void> loadOnlineStatus(String userId) async {
    try {
      state = state.copyWith(isLoading: true);
      final isOnline = await getOnlineStatusUseCase(userId); // <-- يرجع bool
      state = state.copyWith(isOnline: isOnline, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
