import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../user/domain/entities/user_entity.dart';
import '../../../domain/entities/block/block_user_model.dart';
import '../../../domain/usecase/blocking/block_user_usecase.dart';
import '../../../domain/usecase/blocking/get_blocked_users_usecase.dart';
import '../../../domain/usecase/blocking/unblock_user_usecase.dart';
import '../../../domain/usecase/blocking/clear_massage_usecase.dart';
import '../../../domain/usecase/blocking/is_blocked_users_usecase.dart';

enum BlockUserStatus {
  initial,
  loading,
  blockedSuccessfully,
  unblockedSuccessfully,
  blockFailed,
  unblockFailed,
  clearMessagesSuccess,
  clearMessagesFailed,
  noInternet,
  error,
}

class BlockUserState {
  final BlockUserStatus status;
  final String message;
  final List<UserEntity> blockedContacts; // غيرت من BlockEntity إلى UserModel
  final BlockEntity? block;

  const BlockUserState({
    this.status = BlockUserStatus.initial,
    this.message = '',
    this.blockedContacts = const [],
    this.block,
  });

  BlockUserState copyWith({
    BlockUserStatus? status,
    String? message,
    List<UserEntity>? blockedContacts,
    BlockEntity? block,
  }) {
    return BlockUserState(
      status: status ?? this.status,
      message: message ?? this.message,
      blockedContacts: blockedContacts ?? this.blockedContacts,
      block: block ?? this.block,
    );
  }
}

class BlockUserViewModel extends StateNotifier<BlockUserState> {
  final BlockUserUseCase blockUserUseCase;
  final UnblockUserUseCase unblockUserUseCase;
  final ClearMessagesUseCase clearMessagesUseCase;
  final isBlockedUsersUseCase isblockUserUseCase;
  final Connectivity connectivity;
  final GetBlockedUsersUseCase getBlockedUsersUseCase;

  BlockUserViewModel({
    required this.blockUserUseCase,
    required this.unblockUserUseCase,
    required this.clearMessagesUseCase,
    required this.connectivity,
    required this.isblockUserUseCase,
    required this.getBlockedUsersUseCase,
  }) : super(const BlockUserState());

  String generateChatId(String userAId, String userBId) {
    if (userAId.compareTo(userBId) > 0) {
      return '$userAId-$userBId';
    } else {
      return '$userBId-$userAId';
    }
  }

  Future<void> loadBlockedContacts() async {
    if (state.blockedContacts.isNotEmpty || state.status == BlockUserStatus.loading) {
      return;
    }

    state = state.copyWith(status: BlockUserStatus.loading, message: '');
    try {
      // افترض أن الـ UseCase يرجع List<BlockEntity>
      final blockedList = await getBlockedUsersUseCase.execute();
      state = state.copyWith(
        status: BlockUserStatus.initial,
        blockedContacts: blockedList,
      );
    } catch (e) {
      state = state.copyWith(
        status: BlockUserStatus.blockFailed,
        message: 'Failed to load blocked contacts. Please try again.',
      );
    }
  }

  Future<void> blockUser({
    required String currentUserId,
    required String blockedUserId,
    required String chatId,
  }) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      state = state.copyWith(
        status: BlockUserStatus.noInternet,
        message: 'No internet connection. Please try again.',
      );
      return;
    }

    try {
      await blockUserUseCase.execute(currentUserId: currentUserId, blockedUserId: blockedUserId);
      await clearMessagesUseCase.call(currentUserId: currentUserId, chatId: chatId);
      await loadBlockedContacts();

      state = state.copyWith(
        status: BlockUserStatus.blockedSuccessfully,
        message: 'User blocked and messages cleared successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        status: BlockUserStatus.blockFailed,
        message: 'Failed to block the user or clear messages. Please try again.',
      );
    }
  }

  Future<void> unblockUser({
    required String currentUserId,
  }) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      state = state.copyWith(
        status: BlockUserStatus.noInternet,
        message: 'No internet connection. Please try again.',
      );
      return;
    }

    try {
      await unblockUserUseCase.call(currentUserId: currentUserId, block:state.block!.blockId);
      await loadBlockedContacts();

      state = state.copyWith(
        status: BlockUserStatus.unblockedSuccessfully,
        message: 'User unblocked successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        status: BlockUserStatus.unblockFailed,
        message: 'Failed to unblock the user. Please try again.',
      );
    }
  }

  void resetState() {
    state = const BlockUserState();
  }

  Future<bool> canSeeUserProfile({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return true;
    }

    final currentBlockedOther = await isblockUserUseCase.isBlocked(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );

    final otherBlockedCurrent = await isblockUserUseCase.isBlocked(
      currentUserId: otherUserId,
      otherUserId: currentUserId,
    );

    if (currentBlockedOther || otherBlockedCurrent) {
      return false;
    }

    return true;
  }

  Future<Either<String,bool>> canSendMessage({
    required String currentUserId,
    required String receiverUserId,
  }) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Left('No internet connection. Please check your connection and try again.');
    }

    final currentBlockedReceiver = await isblockUserUseCase.isBlocked(
      currentUserId: currentUserId,
      otherUserId: receiverUserId,
    );

    if (currentBlockedReceiver) {
      return Left('You cannot send messages because you have blocked this user.');
    }

    final receiverBlockedCurrent = await isblockUserUseCase.isBlocked(
      currentUserId: receiverUserId,
      otherUserId: currentUserId,
    );

    if (receiverBlockedCurrent) {
      return Left('You cannot send messages because this user has blocked you.');
    }

    return Right(true);
  }

  Future<void> clearMessages({
    required String currentUserId,
    required String receiverUserId,
    required String chatId,
  }) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      state = state.copyWith(
        status: BlockUserStatus.noInternet,
        message: 'No internet connection. Please try again.',
      );
      return;
    }

    try {
      bool blocked = await isblockUserUseCase.isBlocked(
        currentUserId: currentUserId,
        otherUserId: receiverUserId,
      );

      if (blocked) {
        state = state.copyWith(
          status: BlockUserStatus.clearMessagesFailed,
          message: 'Cannot clear messages because one of the users is blocked.',
        );
        return;
      }

      await clearMessagesUseCase.call(
        currentUserId: currentUserId,
        chatId: chatId,
      );

      state = state.copyWith(
        status: BlockUserStatus.clearMessagesSuccess,
        message: 'Messages cleared successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        status: BlockUserStatus.clearMessagesFailed,
        message: 'Failed to clear messages. Please try again.',
      );
    }
  }

  void clearMessage() {
    state = state.copyWith(message: '');
  }
}
