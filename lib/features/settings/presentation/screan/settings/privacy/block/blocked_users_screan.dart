import 'package:lopechat/features/settings/presentation/screan/settings/privacy/block/select_contact_to_block_screan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../../../profile/presentation/provider/block/vm/viewmodel_provider.dart';
import '../../../../../../profile/presentation/viewmodel/blocking/block_user_viewmodel.dart';
import '../../../../../../user/domain/entities/user_entity.dart';
import '../../../../../../user/provider/get_userdata_provider.dart';
import 'empty_blocked_screan.dart';

class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(blockUserViewModelProvider);
    final viewModel = ref.read(blockUserViewModelProvider.notifier);
    final currentUser = ref.watch(userStreamProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Contacts'),
        leading: const Icon(Icons.block),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SelectContactToBlockScreen()),
              ).then((_) {
                viewModel.loadBlockedContacts();
              });
            },
          ),
        ],
      ),

      body: Builder(
        builder: (_) {
          if (state.status == BlockUserStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == BlockUserStatus.blockFailed) {
            return Center(child: Text(state.message.isEmpty ? 'Unknown error' : state.message));
          }

          if (state.blockedContacts.isEmpty) {
            return const EmptyBlockedListView();
          }

          if (currentUser == null) {
            return const Center(child: Text('Loading user info...'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Contacts',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.blockedContacts.length,
                  itemBuilder: (context, index) {
                    final user = state.blockedContacts[index];

                    return FutureBuilder<bool>(
                      future: ref.read(profilePhotoVisibilityProvider({
                        'currentUserId': currentUser.uid,
                        'otherUserId': user.uid,
                      }).future),
                      builder: (context, snapshot) {
                        final canShowPhoto = snapshot.data ?? false;

                        return GestureDetector(
                          onLongPress: () {
                            _showUnblockDialog(context, user, ref, currentUser.uid);
                          },
                          child: ListTile(
                            leading: canShowPhoto
                                ? CircleAvatar(backgroundImage: NetworkImage(user.profile))
                                : const CircleAvatar(child: Icon(Icons.person_off)),
                            title: Text(user.name),
                            subtitle: Text(user.phoneNumber),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showUnblockDialog(BuildContext context, UserEntity user, WidgetRef ref, String currentUserId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Unblock this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );

              final viewModel = ref.read(blockUserViewModelProvider.notifier);
              await viewModel.unblockUser(currentUserId: currentUserId);

              Navigator.pop(context);

              final message = ref.read(blockUserViewModelProvider).message;
              if (message.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User unblocked successfully')),
                );
              }
            },
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }
}
