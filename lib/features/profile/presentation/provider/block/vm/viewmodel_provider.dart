import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../viewmodel/blocking/block_user_viewmodel.dart';
import '../usecases/clear_massage_usecase_provider.dart';
import '../usecases/get_blocked_users_usecase_provider.dart';
import '../usecases/is_blocked_privacy_usecase_provider.dart';
import '../usecases/unblock_blocked_privacy_usecase_provider.dart';
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});


final blockUserViewModelProvider = StateNotifierProvider<BlockUserViewModel, BlockUserState>((ref) {
  final blockUserUseCase = ref.watch(blockUserUseCaseProvider);
  final unblockUserUseCase = ref.watch(unblockUserUseCaseProvider);
  final isblockUserUseCase = ref.watch(isBlockedUsersUseCaseProvider);
  final clearMessagesUseCase = ref.watch(clearMassageUseCaseProvider);

  final connectivity = ref.watch(connectivityProvider);
  final getBlockedUsersUseCase = ref.watch(getBlockedUsersUseCaseProvider );
  return BlockUserViewModel(
    blockUserUseCase: blockUserUseCase,
    unblockUserUseCase: unblockUserUseCase,
    connectivity: connectivity, isblockUserUseCase:isblockUserUseCase,
    clearMessagesUseCase: clearMessagesUseCase, getBlockedUsersUseCase:getBlockedUsersUseCase,
  );
});
final isBlockedProvider = FutureProvider.family<bool, Map<String, String>>((ref, params) async {
  final currentUserId = params['currentUserId'] ?? '';
  final otherUserId = params['otherUserId'] ?? '';

  if (currentUserId.isEmpty || otherUserId.isEmpty) return false;

  final vm = ref.read(blockUserViewModelProvider.notifier);

  final blocked = await vm.isblockUserUseCase.isBlocked(
    currentUserId: currentUserId,
    otherUserId: otherUserId,
  );

  return blocked;
});
final blockprovider  =
FutureProvider.family<bool, Map<String, String>>((ref, params) async {
  final currentUserId = params['currentUserId'] ?? '';
  final otherUserId = params['otherUserId'] ?? '';

  if (currentUserId.isEmpty || otherUserId.isEmpty) return false;

  final vm = ref.read(blockUserViewModelProvider.notifier);
  return await vm.canSeeUserProfile(
    currentUserId: currentUserId,
    otherUserId: otherUserId,
  );
});

