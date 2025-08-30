import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lopechat/features/profile/presentation/screan/widgets/block_user_titel.dart';
import 'package:lopechat/features/profile/presentation/screan/widgets/encryption_info_screen.dart';
import 'package:lopechat/features/profile/presentation/screan/widgets/report_dialog_widget.dart';
import '../../../../../common/widgets/Loeading.dart';
import '../../../../../constant.dart';

import '../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../chat/presentaion/provider/chat_config/viewmodel/provider.dart';
import '../../../chat/presentaion/provider/user status/vm/provider.dart';
import '../../../contact/presentation/provider/usecases/get_app_contacts_usecases_provider.dart';
import '../../../settings/presentation/provider/privacy/last seen and online/vm/provider.dart';
import '../../../user/provider/get_userdata_provider.dart';
import '../../../user/provider/user_data_by_id_provider.dart';
import '../provider/block/vm/viewmodel_provider.dart';
import '../provider/lock/viewmodel/provider.dart';
import '../provider/report/vm/provider.dart';
import '../viewmodel/blocking/block_user_viewmodel.dart';
import '../viewmodel/lock/lock_viewmodel.dart';
import '../viewmodel/report/report_viewmodel.dart';

class ProfileChat extends ConsumerStatefulWidget {
  const ProfileChat({
    Key? key,
    required this.name,
    required this.uid,
    required this.profilePic,
  }) : super(key: key);

  final String name;
  final String uid;
  final String profilePic;

  @override
  ConsumerState<ProfileChat> createState() => _ProfileChatState();
}

class _ProfileChatState extends ConsumerState<ProfileChat> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(disappearingMessagesViewModelProvider.notifier)
          .listenToConfig(widget.uid);

      // Listen for block, report, lock state changes and show snackbars
      ref.listen<BlockUserState>(
        blockUserViewModelProvider,
            (previous, next) {
          if (next.message.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(next.message)),
            );
            ref.read(blockUserViewModelProvider.notifier).clearMessage();
          }
        },
      );

      ref.listen<ReportState>(
        reportViewModelProvider,
            (previous, next) {
          if (next.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(next.successMessage!)),
            );
            ref.read(reportViewModelProvider.notifier).clearMessages();
          } else if (next.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(next.errorMessage!)),
            );
            ref.read(reportViewModelProvider.notifier).clearMessages();
          }
        },
      );

      ref.listen<ChatLockState>(
        chatLockViewModelProvider(widget.uid),
            (previous, next) {
          if (next.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(next.successMessage!)),
            );
            ref.read(chatLockViewModelProvider(widget.uid).notifier).clearMessages();
          } else if (next.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(next.errorMessage!)),
            );
            ref.read(chatLockViewModelProvider(widget.uid).notifier).clearMessages();
          }
        },
      );

      // Load last seen & online data
      Future.microtask(() async {
        final currentUser = ref.read(userStreamProvider).value;
        if (currentUser != null) {
          final contacts = await ref.read(someProvider(widget.uid)).call();
          ref.read(lastSeenAndOnlineViewModelProvidering(widget.uid).notifier)
              .loadDataForUser(widget.uid, contacts);
        }
      });
      ref.read(lastSeenAndOnlineViewModelProvidering(widget.uid).notifier)
          .loadDataForUser(widget.uid, []);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userByIdProvider(widget.uid));
    final disappearingState = ref.watch(disappearingMessagesViewModelProvider);
    final disappearingVM = ref.read(disappearingMessagesViewModelProvider.notifier);
    final currentUser = ref.watch(userStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: kkPrimaryColor),
        ),
      ),
      backgroundColor: Colors.white,
      body: userAsyncValue.when(
        loading: () => const Loeading(),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (user) {
          return currentUserId == null
              ? const SizedBox()
              : Consumer(
            builder: (context, ref, _) {
              final profilePhotoAsync = ref.watch(
                profilePhotoVisibilityProvider({
                  'currentUserId': currentUserId,
                  'otherUserId': user.uid,
                }),
              );

              return profilePhotoAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
                data: (showProfilePhoto) {
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: showProfilePhoto && user.profile.isNotEmpty
                                ? CachedNetworkImageProvider(user.profile)
                                : null,
                            backgroundColor: Colors.grey,
                            child: !showProfilePhoto
                                ? const Icon(Icons.block, size: 70, color: Colors.red)
                                : (user.profile.isEmpty
                                ? const Icon(Icons.person, size: 70, color: Colors.white)
                                : null),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(user.phoneNumber, style: const TextStyle(fontSize: 20)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Text(user.name, style: const TextStyle(fontSize: 18)),
                          ),
                          Consumer(
                            builder: (context, ref, _) {
                              final userStatusState = ref.watch(userStatusViewModelProvider);
                              final lastSeenVM = ref.read(lastSeenAndOnlineViewModelProvidering(user.uid).notifier);
                              final currentUserAsync = ref.watch(userStreamProvider);

                              return currentUserAsync.when(
                                data: (currentUser) {
                                  if (currentUser == null) return const SizedBox();

                                  final canSeeLastSeen = lastSeenVM.canSeeLastSeen(currentUser.uid);
                                  final canSeeOnline = lastSeenVM.canSeeOnlineStatus(currentUser.uid);

                                  String text = '';

                                  if (userStatusState.isOnline && canSeeOnline) {
                                    text = 'Online';
                                  } else if (canSeeLastSeen && userStatusState.lastSeen != null) {
                                    text = 'Last Seen: ${userStatusState.lastSeen}';
                                  }

                                  return Text(text, style: const TextStyle(fontSize: 12));
                                },
                                loading: () => const SizedBox(),
                                error: (_, __) => const SizedBox(),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Text(
                              user.statu,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildIconButton(
                                icon: Icons.call,
                                onPressed: () {},
                                screenWidth: MediaQuery.of(context).size.width,
                              ),
                              _buildIconButton(
                                icon: Icons.video_call,
                                onPressed: () {},
                                screenWidth: MediaQuery.of(context).size.width,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.black87),
                          buildListTile(
                            icon: Icons.enhanced_encryption,
                            title: "Encryption",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const EncryptionInfoScreen()));
                            },
                          ),
                          buildListTile(
                            icon: Icons.hide_source_rounded,
                            title: "Disappearing messages",
                            subtitle: disappearingState.isEnabled
                                ? "On - ${disappearingState.durationSeconds ~/ 3600} hours"
                                : "Off",
                            onTap: () async {
                              final newValue = !disappearingState.isEnabled;
                              await disappearingVM.toggleDisappearingMessages(widget.uid, newValue, 86400);
                            },
                          ),
                          if (disappearingState.isLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: LinearProgressIndicator(),
                            ),
                          if (disappearingState.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Error: ${disappearingState.errorMessage}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          _buildLockChatTile(widget.uid),
                          const Divider(color: Colors.black87),
                          BlockToggleButton(
                            currentUserId: currentUserId,
                            otherUserId: widget.uid,
                          ),
                          ListTile(
                            leading: const Icon(Icons.report, color: Colors.orange, size: 20),
                            title: const Text(
                              'Report User',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.orange,
                              ),
                            ),
                            onTap: () => _showReportDialog(context, ref, widget.name, widget.uid),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Function() onPressed,
    required double screenWidth,
  }) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((0.4 * 255).toInt()),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: IconButton(
          icon: Icon(icon, color: kkPrimaryColor),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color titleColor = Colors.black,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: kkPrimaryColor),
      title: Text(
        title,
        style: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
    );
  }

  Widget _buildLockChatTile(String chatId) {
    final isLocked = ref.watch(chatLockViewModelProvider(chatId)).isLocked;
    final notifier = ref.read(chatLockViewModelProvider(chatId).notifier);
    return ListTile(
      leading: const Icon(Icons.lock_clock_outlined, color: Colors.grey),
      title: const Text("Lock and hide this chat on this device"),
      trailing: Switch(
        value: isLocked,
        onChanged: (_) => notifier.toggleLock(chatId),
      ),
    );
  }

  void _showReportDialog(BuildContext context, WidgetRef ref, String reportedUserName, String reportedUserId) {
    final reportVM = ref.read(reportViewModelProvider.notifier);

    showDialog(
      context: context,
      builder: (context) {
        return ReportDialog(
          reportedUserName: reportedUserName,
          onCancel: () => Navigator.of(context).pop(),
          onReportConfirm: (reason) async {
            Navigator.of(context).pop();
            await reportVM.reportUser(
              reportedUserId: reportedUserId,
              reason: reason,
            );
          },
        );
      },
    );
  }
}
