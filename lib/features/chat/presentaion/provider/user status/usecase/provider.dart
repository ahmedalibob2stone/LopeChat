
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecase/user status/get_user_last_seen_usecase.dart';
import '../../../../domain/usecase/user status/get_user_online_status_usecase.dart';
import '../../../../domain/usecase/user status/update_user_status_usecase.dart';
import '../data/provider.dart';

final updateUserUseCaseProvider = Provider<UpdateUserusUseCase>((ref) {
  final repo = ref.watch(userStatusRepositoryProvider);
  return UpdateUserusUseCase(repo);
});

final getUserLastSeenUseCaseProvider = Provider<GetUserLastSeenUseCase>((ref) {
  final repo = ref.watch(userStatusRepositoryProvider);
  return GetUserLastSeenUseCase(repo);
});

final getUserOnlineStatusUseCaseProvider = Provider<GetUserOnlineStatusUseCase>((ref) {
  final repo = ref.watch(userStatusRepositoryProvider);
  return GetUserOnlineStatusUseCase(repo);
});
