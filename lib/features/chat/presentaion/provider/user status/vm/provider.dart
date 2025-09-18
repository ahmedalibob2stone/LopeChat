import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodel/user status/user_status_viewmodel.dart';
import '../usecase/provider.dart';

final userStatusViewModelProvider = StateNotifierProvider<UserStatusViewModel, UserStatusState>((ref) {
  final update = ref.read(updateUserUseCaseProvider);
  final lastSeen = ref.read(getUserLastSeenUseCaseProvider);
  final onlineStatus = ref.read(getUserOnlineStatusUseCaseProvider);

  return UserStatusViewModel(
    updateStatusUseCase: update,
    getLastSeenUseCase: lastSeen,
    getOnlineStatusUseCase: onlineStatus,
  );
});
