import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../settings/presentation/provider/privacy/camera effect/vm/camera_affects_viewmodel_provider.dart';
import '../../../user/provider/get_userdata_provider.dart';
import '../provider/viewmode/provider.dart';
import 'call_screan.dart';
import '../../../../common/Provider/profile_phote_visiblity_provider.dart';

class CallListScreen extends ConsumerWidget {
  final bool  isGroupChat;
  
  const CallListScreen({ required this.isGroupChat,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(callHistoryViewModelProvider);
    final callController = ref.read(callHistoryViewModelProvider.notifier);
    final cameraEffectsEnabled = ref.watch(cameraEffectsEnabledProvider);
    final ipProtectionEnabled = ref.watch(ipProtectionEnabledProvider);

    final currentUser = ref.watch(userStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Call History"),
      ),
      body: callState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : callState.error != null
          ? Center(child: Text('Error: ${callState.error}'))
          : callState.callHistory.isEmpty
          ? const Center(child: Text("No calls found"))
          : ListView.builder(
        itemCount: callState.callHistory.length,
        itemBuilder: (context, index) {
          final call = callState.callHistory[index];

          final profileVisibilityAsync = (currentUserId != null)
              ? ref.watch(profilePhotoVisibilityProvider({
            'currentUserId': currentUserId,
            'otherUserId': call.callerId,
          }))
              : AsyncValue.data(false);

          return profileVisibilityAsync.when(
            loading: () => const ListTile(
              title: Text("Loading..."),
              leading: CircularProgressIndicator(),
            ),
            error: (error, _) => ListTile(
              title: Text("Error: $error"),
            ),
            data: (canViewPhoto) {
              return Slidable(
                key: Key(call.callId),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        callController.deleteCall(call.callerId);
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                      backgroundColor: Colors.red,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: canViewPhoto
                        ? NetworkImage(
                       isGroupChat
                            ? call.callerPic // صورة المجموعة إذا كانت جماعية
                            : (currentUserId == call.callerId ? call.receiverPic : call.callerPic)
                    )
                        : null,
                    child: canViewPhoto
                        ? null
                        : const Icon(Icons.person),
                  ),

                  title: Text(call.callerName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(call.receiverName),
                      Text(
                        DateFormat.yMMMd().format(call.timestamp),
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    call.hasDialled ? Icons.call_made : Icons.call_received,
                    color: call.hasDialled ? Colors.red : Colors.green,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          channelId: call.callId,
                          call: call,
                          isGroupChat: isGroupChat,
                          cameraEffectsEnabled: cameraEffectsEnabled,
                          ipProtectionEnabled: ipProtectionEnabled, isVideo: call.isVideo,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
