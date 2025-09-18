import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../settings/presentation/provider/privacy/camera effect/vm/camera_affects_viewmodel_provider.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../provider/viewmode/provider.dart';
import 'call_screan.dart';

class CallListScreen extends ConsumerWidget {
  final bool isGroupChat;

  const CallListScreen({required this.isGroupChat, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(callHistoryViewModelProvider);
    final callController = ref.read(callHistoryViewModelProvider.notifier);
    final cameraEffectsEnabled = ref.watch(cameraEffectsEnabledProvider);
    final ipProtectionEnabled = ref.watch(ipProtectionEnabledProvider);


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
          final currentUser = ref.watch(currentUserStreamProvider).asData?.value;
          final currentUserId = currentUser?.uid;
          final userCallerAsync = (call.callerId.isNotEmpty)
              ? ref.watch(userByIdStreamProvider(call.callerId))
              : AsyncValue.data(null);

          return userCallerAsync.when(
            loading: () => const ListTile(
              title: Text("Loading..."),
              leading: CircularProgressIndicator(),
            ),
            error: (error, _) => ListTile(
              title: Text("Error: $error"),
              leading: const Icon(Icons.error),
            ),
            data: (user) {
              final canViewPhoto = user != null && user.profile.isNotEmpty;

              return Slidable(
                key: Key(call.callId),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => callController.deleteCall(call.callerId),
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
                          ? call.callerPic
                          : (currentUserId == call.callerId
                          ? call.receiverPic
                          : call.callerPic),
                    )
                        : null,
                    child: canViewPhoto ? null : const Icon(Icons.person),
                  ),
                  title: Text(user?.name ?? call.callerName),
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
                        builder: (_) => CallScreen(
                          channelId: call.callId,
                          call: call,
                          isGroupChat: isGroupChat,
                          cameraEffectsEnabled: cameraEffectsEnabled,
                          ipProtectionEnabled: ipProtectionEnabled,
                          isVideo: call.isVideo,
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
