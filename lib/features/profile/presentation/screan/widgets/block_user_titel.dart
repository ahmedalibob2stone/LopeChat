import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/block/vm/viewmodel_provider.dart';
import '../../viewmodel/blocking/block_user_viewmodel.dart';



class BlockToggleButton extends ConsumerWidget {
  final String currentUserId;
  final String otherUserId;

  const BlockToggleButton({
    Key? key,
    required this.currentUserId,
    required this.otherUserId,
  }) : super(key: key);

  Future<bool?> _showConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('block '),
          content: const Text('are you sure want block this user؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockUserState = ref.watch(blockUserViewModelProvider);
    final blockUserVM = ref.read(blockUserViewModelProvider.notifier);

    final isLoading = blockUserState.status == BlockUserStatus.blockFailed ||
        blockUserState.status == BlockUserStatus.unblockFailed
        ? false
        : blockUserState.status == BlockUserStatus.blockedSuccessfully ||
        blockUserState.status == BlockUserStatus.unblockedSuccessfully
        ? false
        : false;

    final isBlockedAsync = ref.watch(isBlockedProvider({'currentUserId': currentUserId, 'otherUserId': otherUserId}));

    return isBlockedAsync.when(
      data: (isBlocked) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isBlocked ? Colors.grey[600] : Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: isLoading ? null : () async {
            if (isBlocked) {
              // إلغاء الحظر مباشر بدون حوار
              await blockUserVM.unblockUser(
                currentUserId: currentUserId,
              );
            } else {
              final chatId = blockUserVM.generateChatId(currentUserId, otherUserId);

              final confirm = await _showConfirmDialog(context);
              if (confirm == true) {
                await blockUserVM.blockUser(
                  currentUserId: currentUserId,
                  blockedUserId: otherUserId,
                  chatId: chatId,
                );
              }
            }
          },
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
            isBlocked ? 'إلغاء الحظر' : 'حظر',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('حدث خطأ: $error'),
    );
  }
}
