  import 'package:cached_network_image/cached_network_image.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  import '../../../../common/Provider/profile_phote_visiblity_provider.dart';
  import '../../../call/domain/entites/callentites.dart';
  import '../../../call/presentation/provider/viewmode/provider.dart';
  import '../../../call/presentation/view/call_pickup_screan.dart';
  import '../../../call/presentation/view/call_screan.dart';
  import '../../../call/presentation/viewmodel/call_session_viewmodel.dart';
import '../../../call/presentation/viewmodel/craete_call_viewmodel.dart';
import '../../../contact/presentation/provider/stream/gat_app_contact_stream_provider.dart';
  import '../../../contact/presentation/provider/vm/get_app_contact_viewmodel_provider.dart';
  import '../../../group/presentation/provider/viewmodel/provider.dart';
  import '../../../profile/presentation/provider/block/vm/viewmodel_provider.dart';
  import '../../../settings/presentation/provider/privacy/advanced/vm/advanced_privacy_viewmodel_provider.dart';
  import '../../../settings/presentation/provider/privacy/camera effect/vm/camera_affects_viewmodel_provider.dart';
  import '../../../settings/presentation/provider/privacy/last seen and online/vm/provider.dart';
  import '../../../settings/presentation/provider/privacy/profile/vm/provider.dart';
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

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return; // ✅ حماية من dispose

        await userStatusVM.updateStatus(true);

        final currentUser = ref.read(currentUserStreamProvider).value;

        if (currentUser != null && currentUser.uid != widget.uid) {
          await userStatusVM.loadLastSeen(widget.uid);
          await userStatusVM.loadOnlineStatus(widget.uid);

          final contacts = await ref.read(someProvider(widget.uid)).call();

          if (!mounted) return; // ✅ حماية إضافية
          await ref.read(
              lastSeenAndOnlineViewModelProvidering(widget.uid).notifier
          ).loadDataForUser(widget.uid, contacts);
        }

        if (!mounted) return; // ✅ حماية قبل استدعاء التالي
        await ref
            .read(getAppContactsViewModelProvider.notifier)
            .loadAppContacts();
        if (!mounted) return;
        final contacts = ref.read(getAppContactsViewModelProvider).contacts;
        await ref.read(profilePrivacyProvider.notifier).loadData(contacts);
      });
    }


    @override
    void dispose() {
      Future.microtask(() {
        userStatusVM.updateStatus(false);
      });

      super.dispose();
    }
    Future<void> _startCall({
      required String name,
      required String uid,
      required String profilePic,
      required bool isGroupChat,
      required bool isVideo,
    }) async {
      // احصل على المستخدم الحالي من الـ StreamProvider
      final currentUser = ref.watch(currentUserStreamProvider).asData?.value;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Current user not loaded yet")),
        );
        return;
      }

      final callId = DateTime.now().millisecondsSinceEpoch.toString();
      final timestamp = DateTime.now();

      // إعداد بيانات المكالمة للمرسل والمستقبل
      final senderCall = CallEntites(
        callerId: currentUser.uid,
        callerName: currentUser.name,
        callerPic: currentUser.profile,
        receiverId: uid,
        receiverName: name,
        receiverPic: profilePic,
        callId: callId,
        hasDialled: true,
        timestamp: timestamp,
        isVideo: isVideo,
      );

      final receiverCall = CallEntites(
        callerId: currentUser.uid,
        callerName: currentUser.name,
        callerPic: currentUser.profile,
        receiverId: uid,
        receiverName: name,
        receiverPic: profilePic,
        callId: callId,
        hasDialled: false,
        timestamp: timestamp,
        isVideo: isVideo,
      );

      // قراءة الإعدادات الأخرى
      final cameraEffectsEnabled = ref.watch(cameraEffectsViewModelProvider).isEnabled;
      final ipProtectionEnabled = ref.watch(advancedPrivacyViewModelProvider).ipProtection;

      try {
        // استدعاء CreateCallViewModel
        final callVM = ref.read(createCallViewModelProvider.notifier);

        // إنشاء المكالمة
        await callVM.createCall(
          senderCall: senderCall,
          receiverCall: receiverCall,
          isGroupChat: isGroupChat,
          isVideo: isVideo,
          context: context,
        );

        // التحقق من حالة المكالمة بعد التنفيذ
        final state = callVM.state;
        if (state.status == CallCreateStatus.success) {
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CallScreen(
                channelId: callId,
                call: senderCall,
                isGroupChat: isGroupChat,
                cameraEffectsEnabled: cameraEffectsEnabled,
                ipProtectionEnabled: ipProtectionEnabled,
                isVideo: isVideo,
              ),
            ),
          );
        } else if (state.status == CallCreateStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to start call: ${state.errorMessage ?? 'Unknown error'}"),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected error: $e")),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      final isLargeScreen = MediaQuery
          .of(context)
          .size
          .width > 600;

      if (widget.isGroupChat) {
        final groupState = ref.watch(
            groupInformationViewModelProvider(widget.uid));

        if (groupState.isLoading) {
          return const Scaffold(body: Center(
              child: CircularProgressIndicator(color: Colors.black,)));
        } else if (groupState.errorMessage != null) {
          return Scaffold(
              body: Center(child: Text("Error: ${groupState.errorMessage}")));
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
      } else {
        final currentUserAsync = ref.watch(currentUserStreamProvider);

        return currentUserAsync.when(
          data: (currentUser) {
            final displayName = widget.name ?? 'User';
            final displayPic = widget.profilePic ?? '';

            return _buildChatScreen(
              context,
              displayName,
              displayPic,
              isLargeScreen,
            );
          },
          loading: () =>
          const Scaffold(
            body: Center(
                child: CircularProgressIndicator(color: Colors.amber,)),
          ),
          error: (e, _) =>
              Scaffold(
                body: Center(child: Text('Error loading user: $e')),
              ),
        );
      }
    }
    Widget _buildChatScreen(
        BuildContext context,
        String displayName,
        String displayPic,
        bool isLargeScreen,
        ) {
      // مراقبة إعدادات عامة
      final cameraEffectsEnabled = ref.watch(cameraEffectsViewModelProvider).isEnabled;
      final ipProtectionEnabled = ref.watch(advancedPrivacyViewModelProvider).ipProtection;

      final currentUser = ref.watch(currentUserStreamProvider).asData?.value;
      final currentUserId = currentUser?.uid ?? '';

      // حماية من استخدام ref بعد dispose
      if (!mounted) {
        return const SizedBox.shrink();
      }

      // الآن تم إزالة أي مزود Async

      return CallPickUp(
        cameraEffectsEnabled: cameraEffectsEnabled,
        ipProtectionEnabled: ipProtectionEnabled,
        scaffold: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: isLargeScreen ? 30 : 20,
                  backgroundImage: displayPic.isNotEmpty
                      ? CachedNetworkImageProvider(displayPic)
                      : null,
                  child: displayPic.isNotEmpty
                      ? null
                      : const Icon(Icons.person, size: 30, color: Colors.white),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 10),
                Flexible( // ✅ مهم لتجنب overflow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: isLargeScreen ? 20 : 17,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis, // ✅ تقطع النص إذا طويل
                      ),
                      if (!widget.isGroupChat)
                        Consumer(
                          builder: (context, ref, _) {
                            final userStatusState = ref.watch(userStatusViewModelProvider);
                            final lastSeenVM = ref.read(
                              lastSeenAndOnlineViewModelProvidering(widget.uid).notifier,
                            );

                            String statusText = '';
                            if (userStatusState.isOnline &&
                                lastSeenVM.canSeeOnlineStatus(currentUserId)) {
                              statusText = 'Online';
                            } else if (lastSeenVM.canSeeLastSeen(currentUserId) &&
                                userStatusState.lastSeen != null) {
                              statusText = 'Last Seen: ${userStatusState.lastSeen}';
                            }

                            if (statusText.isEmpty) statusText = 'Status unavailable';

                            return Text(
                              statusText,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis, // ✅ تقطع النص إذا طويل
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            )
,
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
                      isGroupChat: widget.isGroupChat,
                      isVideo: true,
                    ),
                    icon: callState is AsyncLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.amber,
                      ),
                    )
                        : Icon(Icons.video_call, size: isLargeScreen ? 30 : 24),
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
                        isGroupChat: false,
                        isVideo: false,
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
        ),
        isGroupChat: widget.isGroupChat,
      );
    }



  }
