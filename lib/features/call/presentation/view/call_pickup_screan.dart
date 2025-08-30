import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../user/provider/get_userdata_provider.dart';
import '../../data/model/call/call_model.dart';
import '../../domain/entites/callentites.dart';
import '../provider/viewmode/provider.dart';
import '../view/call_screan.dart';

class CallPickUp extends ConsumerWidget {
  final Widget scaffold;
  final bool cameraEffectsEnabled;
  final bool ipProtectionEnabled;
  final bool isGroupChat;

  const CallPickUp({
    Key? key,
    required this.scaffold,
    required this.cameraEffectsEnabled,
    required this.ipProtectionEnabled,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callSnapshot = ref.watch(incomingCallProvider);

    return callSnapshot.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("Error: $error")),
      data: (doc) {
        if (!doc.exists || doc.data() == null) {
          return scaffold;
        }

        final callModel = CallModel.fromMap(doc.data() as Map<String, dynamic>);
        final CallEntites call = callModel.toEntity();

        final currentUser = ref.watch(userStreamProvider).asData?.value;
        final currentUserId = currentUser?.uid;

        if (currentUserId == null) {
          return scaffold;
        }
        final profileVisibilityAsync = ref.watch(profilePhotoVisibilityProvider({
          'currentUserId': currentUserId,
          'otherUserId': call.callerId,
        }));

        return profileVisibilityAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text("Error: $error")),
          data: (isBlocked) {
            if (isBlocked) {
              // If the caller is blocked, do not show the incoming call
              return scaffold;
            }

            // Use profilePhotoVisibilityProvider to check if caller's profile can be seen
            final profileVisibilityAsync = ref.watch(profilePhotoVisibilityProvider({
              'currentUserId': currentUserId,
              'otherUserId': call.callerId,
            }));

            return profileVisibilityAsync.when(
              data: (canViewPhoto) {
                if (!call.hasDialled) {
                  return Scaffold(
                    body: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Incoming Call',
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                          const SizedBox(height: 50),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: canViewPhoto && call.callerPic.isNotEmpty
                                ? NetworkImage(call.callerPic)
                                : null,
                            child: canViewPhoto ? null : const Icon(Icons.person, size: 40),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            call.callerName,
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 60),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  ref.read(callSessionViewModelProvider.notifier).endCall(
                                    call.callerId,
                                    call.receiverId,
                                  );
                                },
                                icon: const Icon(Icons.call_end, color: Colors.redAccent),
                              ),
                              const SizedBox(width: 25),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CallScreen(
                                        channelId: call.callId,
                                        call: call,
                                        isGroupChat: false,
                                        cameraEffectsEnabled: cameraEffectsEnabled,
                                        ipProtectionEnabled: ipProtectionEnabled, isVideo: isGroupChat ? true : call.isVideo,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.call, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return scaffold;
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => scaffold,
            );
          },
        );
      },
    );
  }
}
