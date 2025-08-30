import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/user status/get_user_last_seen_usecase.dart';
import '../../../domain/usecase/user status/get_user_online_status_usecase.dart';
import '../../../domain/usecase/user status/update_user_status_usecase.dart';

class UserStatusState  {
  final bool isOnline;
  final String? lastSeen;
  final String? onlineStatus;
  final bool isLoading;
  final String? error;

  const UserStatusState({
    this.isOnline = false,
    this.lastSeen,
    this.onlineStatus,
    this.isLoading = false,
    this.error,
  });

  UserStatusState copyWith({
    bool? isOnline,
    String? lastSeen,
    String? onlineStatus,
    bool? isLoading,
    String? error,
  }) {
    return UserStatusState(
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isOnline, lastSeen, onlineStatus, isLoading, error];
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

  Future<void> updateStatus(bool isOnline) async {
    try {
      state = state.copyWith(isLoading: true);
      await updateStatusUseCase(isOnline: isOnline);
      state = state.copyWith(isOnline: isOnline, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> loadLastSeen(String userId) async {
    try {
      state = state.copyWith(isLoading: true);
      final lastSeen = await getLastSeenUseCase(userId);
      state = state.copyWith(lastSeen: lastSeen, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> loadOnlineStatus(String userId) async {
    try {
      state = state.copyWith(isLoading: true);
      final onlineStatus = await getOnlineStatusUseCase(userId);
      state = state.copyWith(onlineStatus: onlineStatus, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

}
