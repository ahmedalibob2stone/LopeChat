import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../config/agora_Developer.dart';
import '../../../contact/presentation/provider/usecases/get_app_contacts_usecases_provider.dart';
import '../../../settings/presentation/provider/privacy/profile/vm/provider.dart';
import '../../../user/provider/get_userdata_provider.dart';
import '../../domain/entites/callentites.dart';
import '../provider/viewmode/provider.dart';
import '../viewmodel/call_session_viewmodel.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final CallEntites call;
  final bool isGroupChat;
  final bool cameraEffectsEnabled;
  final bool ipProtectionEnabled;
   final bool isVideo;

  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
    required this.cameraEffectsEnabled,
    required this.ipProtectionEnabled,
    required this.isVideo,
  }) : super(key: key);

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  bool _isCallInitialized = false;

  @override
  void initState() {
    super.initState();
    ref.listen<CallState>(callSessionViewModelProvider, (previous, next) {
      if (next.status == CallStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'An error occurred')),
        );
      }
    });
    Future.microtask(() async {
      final contacts = await ref.read(getAppContactsUseCaseProvider).call();
      await ref.read(profilePrivacyProvider.notifier).loadData(contacts);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isCallInitialized) {
      _isCallInitialized = true;

      final callVM = ref.read(callSessionViewModelProvider.notifier);

      callVM.initCall(
        appId: AgoragConfig.appId,
        channelId: widget.channelId,
        uid: widget.call.receiverId.hashCode,
        isVideo: widget.isVideo,
        isGroupChat: widget.isGroupChat,
        groupId: widget.isGroupChat ? widget.call.receiverId : null,
        relay: widget.ipProtectionEnabled,
      ).then((_) {
        if (widget.cameraEffectsEnabled && widget.isVideo) {
          _enableCameraEffects(callVM.engine);
        }
      });
    }
  }

  void _enableCameraEffects(RtcEngine engine) {
    engine.setBeautyEffectOptions(
      enabled: true,
      options: BeautyOptions(
        lighteningContrastLevel: LighteningContrastLevel.lighteningContrastNormal,
        lighteningLevel: 0.7,
        smoothnessLevel: 0.5,
        rednessLevel: 0.1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callSessionViewModelProvider);
    final callController = ref.read(callSessionViewModelProvider.notifier);

    if (callState.status == CallStatus.loading || callState.status == CallStatus.idle) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (callState.status == CallStatus.error) {
      return Scaffold(
        body: Center(child: Text('An error occurred: ${callState.errorMessage}')),
      );
    }

    final currentUser = ref.watch(userStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid;

    if (currentUserId == null) {
      return const Scaffold(body: Center(child: Text("Loading user data...")));
    }

    final profileVisibilityAsync = ref.watch(
      profilePhotoVisibilityProvider({
        'currentUserId': currentUserId,
        'otherUserId': widget.call.receiverId,
      }),
    );

    return profileVisibilityAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text("Error: $error"))),
      data: (isBlocked) {
        if (isBlocked) {
          return const Scaffold(
            body: Center(child: Text("You cannot call this user.")),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              if (widget.isVideo)
              if (callState.remoteUid != null)
                AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: callController.engine,
                    canvas: VideoCanvas(uid: callState.remoteUid!),
                    connection: RtcConnection(channelId: widget.channelId),
                  ),
                )
              else
                const Center(
                  child: Text(
                    "Waiting for the other user...",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              if (widget.isVideo)
              Positioned(
                top: 40,
                left: 20,
                width: 120,
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: callController.engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(

                  padding: const EdgeInsets.only(bottom: 30),

                  child:
        Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.call_end),
        onPressed: () async {
        await callController.leaveCall(
        callerId: widget.call.callerId,
        receiverId: widget.call.receiverId,
        );
        if (Navigator.canPop(context)) Navigator.pop(context);
             },
                ),
        if (!widget.isVideo) ...[
        const SizedBox(width: 20),
        FloatingActionButton(
        heroTag: 'mute_mic',
        backgroundColor: Colors.grey,
        child: const Icon(Icons.mic_off),
        onPressed: () {
        callController.engine.muteLocalAudioStream(true);
        },
        ),
        ],


        ]



                ),

              ),
        )
        ]
          ),
        );
      },
    );
  }
}
