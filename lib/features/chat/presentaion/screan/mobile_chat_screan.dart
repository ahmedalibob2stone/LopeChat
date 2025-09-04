import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../call/domain/entites/callentites.dart';
import '../../../call/presentation/provider/viewmode/provider.dart';
import '../../../call/presentation/view/call_pickup_screan.dart';
import '../../../call/presentation/view/call_screan.dart';
import '../../../contact/presentation/provider/usecases/get_app_contacts_usecases_provider.dart';
import '../../../contact/presentation/provider/vm/get_app_contact_viewmodel_provider.dart';
import '../../../group/presentation/provider/viewmodel/provider.dart';
import '../../../profile/presentation/provider/block/vm/viewmodel_provider.dart';
import '../../../settings/presentation/provider/privacy/advanced/vm/advanced_privacy_viewmodel_provider.dart';
import '../../../settings/presentation/provider/privacy/camera effect/vm/camera_affects_viewmodel_provider.dart';
import '../../../settings/presentation/provider/privacy/last seen and online/vm/provider.dart';
import '../../../settings/presentation/provider/privacy/profile/vm/provider.dart';
import '../../../user/presentation/provider/stream_provider/get_user_data_stream_provider.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../provider/user status/vm/provider.dart';
import 'Bottomfileforchat.dart';
import 'chat_list.dart';

class MobileChatScrean extends ConsumerStatefulWidget {
  final String uid;
  final bool isGroupChat;
  final String? name;
  final String? profilePic;

  const MobileChatScrean({
    Key? key,
    required this.uid,
    required this.isGroupChat,
    this.name,
    this.profilePic,
  }) : super(key: key);

  @override
  ConsumerState<MobileChatScrean> createState() => _MobileChatScreanState();
}

class _MobileChatScreanState extends ConsumerState<MobileChatScrean> {
  late final userStatusVM = ref.read(userStatusViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();

    userStatusVM.updateStatus(true);
    userStatusVM.loadLastSeen(widget.uid);
    userStatusVM.loadOnlineStatus(widget.uid);

    Future.microtask(() async {
      final currentUser = ref.read(currentUserStreamProvider).value;
      if (currentUser != null) {
        final contacts = await ref.read(someProvider(widget.uid)).call();
        ref.read(lastSeenAndOnlineViewModelProvidering(widget.uid).notifier)
            .loadDataForUser(widget.uid, contacts);
      }
    });

    Future.microtask(() async {
      await ref.read(getAppContactsViewModelProvider.notifier).loadAppContacts();
      final contacts = ref.read(getAppContactsViewModelProvider).contacts;
      await ref.read(profilePrivacyProvider.notifier).loadData(contacts);
    });
  }

  @override
  void dispose() {
    userStatusVM.updateStatus(false);
    super.dispose();
  }

  void _startCall({
    required String name,
    required String uid,
    required String profilePic,
    required bool isGroupChat,
    required bool isVideo,
  }) {
    final userAsync = ref.read(currentUserStreamProvider);
    final cameraEffectsEnabled = ref.read(cameraEffectsViewModelProvider).isEnabled;
    final ipProtectionEnabled = ref.read(advancedPrivacyViewModelProvider).ipProtection;

    userAsync.when(
      data: (currentUser) async {
        if (currentUser == null) return;

        final callId = DateTime.now().millisecondsSinceEpoch.toString();
        final timestamp = DateTime.now();

        final senderCall = CallEntites(
          callerId: currentUser.uid,
          callerName: currentUser.name,
          callerPic: currentUser.profile,
          receiverId: uid,
          receiverName: name,
          receiverPic: profilePic,
          callId: callId,
          hasDialled: true,
          timestamp: timestamp, isVideo: isVideo,
        );

        final receiverCall = CallEntites(
          callerId: currentUser.uid,
          callerName: currentUser.name,
          callerPic: currentUser.profile ,
          receiverId: uid,
          receiverName: name,
          receiverPic: profilePic,
          callId: callId,
          hasDialled: false,
          timestamp: timestamp, isVideo: isVideo,
        );

        final callVM = ref.read(createCallViewModelProvider.notifier);

        try {
          await callVM.createCall(
            context: context,
            senderCall: senderCall,
            receiverCall: receiverCall,
            isGroupChat: isGroupChat, isVideo: isVideo,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CallScreen(
                channelId: callId,
                call: senderCall,
                isGroupChat: isGroupChat,
                cameraEffectsEnabled: cameraEffectsEnabled,
                ipProtectionEnabled: ipProtectionEnabled, isVideo: isVideo,
              ),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to start call: $e")),
          );
        }
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Loading user...")),
        );
      },
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading user: $e")),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    final groupState = ref.watch(groupInformationViewModelProvider(widget.uid));

    if (groupState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (groupState.errorMessage != null) {
      return Scaffold(body: Center(child: Text("Error: ${groupState.errorMessage}")));
    } else if (groupState.group != null) {
      final group = groupState.group!;
      return _buildChatScreen(
        context,
        group.name,
        group.groupPic,
        isLargeScreen,
      );
    } else {
      return const Scaffold(
        body: Center(child: Text('Something went wrong')),
      );
    }
  }

  Widget _buildChatScreen(BuildContext context, String displayName, String displayPic, bool isLargeScreen) {
    final cameraEffectsEnabled = ref.watch(cameraEffectsViewModelProvider).isEnabled;
    final ipProtectionEnabled = ref.watch(advancedPrivacyViewModelProvider).ipProtection;

    final currentUser = ref.watch(currentUserStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid;
    final profileVisibilityAsync = currentUserId != null
        ? ref.watch(profilePhotoVisibilityProvider({
      'currentUserId': currentUserId,
      'otherUserId': widget.uid,
    }))
        : AsyncValue.data(false);

    final isBlockedAsync = ref.watch(isBlockedProvider({
      'currentUserId': currentUserId ?? '',
      'otherUserId': widget.uid,
    }));

    return isBlockedAsync.when(
      data: (isBlocked) {
        if (isBlocked) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Blocked'),
            ),
            body: const Center(
              child: Text('You cannot view this chat because you are blocked.'),
            ),
          );
        }

        return profileVisibilityAsync.when(
          data: (canViewPhoto) {
            return CallPickUp(
              cameraEffectsEnabled: cameraEffectsEnabled,
              ipProtectionEnabled: ipProtectionEnabled,
              scaffold: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: isLargeScreen ? 30 : 20,
                        backgroundImage: canViewPhoto && displayPic.isNotEmpty
                            ? CachedNetworkImageProvider(displayPic)
                            : null,
                        child: canViewPhoto
                            ? null
                            : const Icon(Icons.person, size: 30, color: Colors.white),
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: TextStyle(
                              fontSize: isLargeScreen ? 20 : 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!widget.isGroupChat)
                            Consumer(
                              builder: (context, ref, _) {
                                final userStatusState = ref.watch(userStatusViewModelProvider);
                                final lastSeenVM = ref.read(lastSeenAndOnlineViewModelProvidering(widget.uid).notifier);
                                final currentUserAsync = ref.watch(currentUserStreamProvider);

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
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    Consumer(
                      builder: (context, ref, _) {
                        final callState = ref.watch(createCallViewModelProvider);
                        return IconButton(
                          onPressed: callState is AsyncLoading
                              ? null
                              : () => _startCall(
                            name: displayName,
                            uid: widget.uid,
                            profilePic: displayPic,
                            isGroupChat: widget.isGroupChat, // المستخدم يحدد إذا كانت مجموعة
                            isVideo: true, // لأنه ضغط على أيقونة الفيديو
                          ),
                          icon: callState is AsyncLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : Icon(Icons.video_call, size: isLargeScreen ? 30 : 24),
                        );
                      },
                    ),
                    // أيقونة الصوت (تظهر فقط في المحادثات الفردية)
                    if (!widget.isGroupChat)
                      Consumer(
                        builder: (context, ref, _) {
                          final callState = ref.watch(createCallViewModelProvider);
                          return IconButton(
                            onPressed: callState is AsyncLoading
                                ? null
                                : () => _startCall(
                              name: displayName,
                              uid: widget.uid,
                              profilePic: displayPic,
                              isGroupChat: false, // دائماً فردي للصوت
                              isVideo: false, // لأنه ضغط على أيقونة الصوت
                            ),
                            icon: callState is AsyncLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : Icon(Icons.call, size: isLargeScreen ? 30 : 24),
                          );
                        },
                      ),
                    if (!widget.isGroupChat)
                      Consumer(
                        builder: (context, ref, _) {
                          final callState = ref.watch(createCallViewModelProvider);
                          return IconButton(
                            onPressed: callState is AsyncLoading
                                ? null
                                : () => _startCall(
                              name: displayName,
                              uid: widget.uid,
                              profilePic: displayPic,
                              isGroupChat: false, // دائماً فردي
                              isVideo: false,     // مكالمة صوتية
                            ),
                            icon: callState is AsyncLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : Icon(Icons.call, size: isLargeScreen ? 30 : 24),
                          );
                        },
                      ),

                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_vert, size: isLargeScreen ? 30 : 24),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ChatList(
                        reciverUserId: widget.uid,
                        isGroupChat: widget.isGroupChat,
                      ),
                    ),
                    BottomFileforChat(
                      chatId: widget.uid,
                      isGroupChat: widget.isGroupChat,
                    ),
                  ],
                ),
              ), isGroupChat:widget.isGroupChat,
            );
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Scaffold(
            body: Center(child: Text('Error checking profile visibility: $e')),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error checking blocked status: $e')),
      ),
    );
  }
}
