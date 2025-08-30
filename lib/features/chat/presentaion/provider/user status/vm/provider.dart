import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodel/user status/user_status_viewmodel.dart';
import '../usecase/provider.dart';

final userStatusViewModelProvider = StateNotifierProvider<UserStatusViewModel, UserStatusState>((ref) {
  final update = ref.watch(updateUserUseCaseProvider);
  final lastSeen = ref.watch(getUserLastSeenUseCaseProvider);
  final onlineStatus = ref.watch(getUserOnlineStatusUseCaseProvider);

  return UserStatusViewModel(
    updateStatusUseCase: update,
    getLastSeenUseCase: lastSeen,
    getOnlineStatusUseCase: onlineStatus,
  );
});
