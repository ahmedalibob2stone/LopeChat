import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../common/selected_chat.dart';
import '../provider/chat_contact/viewmodel/provider.dart';
import '../provider/chat_group/viewmodel/provider.dart';
class ArchivedChatsScreen extends ConsumerStatefulWidget {
  const ArchivedChatsScreen({super.key});

  @override
  ConsumerState<ArchivedChatsScreen> createState() => _ArchivedChatsScreenState();
}

class _ArchivedChatsScreenState extends ConsumerState<ArchivedChatsScreen> {
  final Set<SelectedChat> selectedChats = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatContactViewModelProvider.notifier).loadArchivedChats();
      ref.read(GroupArchivingViewModelProvider.notifier).loadArchivedChats();
    });
  }

  void toggleSelection(SelectedChat chat) {
    setState(() {
      if (selectedChats.contains(chat)) {
        selectedChats.remove(chat);
      } else {
        selectedChats.add(chat);
      }
    });
  }

  Future<void> unarchiveSelectedChats() async {
    final contactVM = ref.read(chatContactViewModelProvider.notifier);
    final groupVM = ref.read(GroupArchivingViewModelProvider.notifier);

    for (var chat in selectedChats) {
      if (chat.isGroup) {
        await groupVM.unarchiveGroup(chat.id);
      } else {
        await contactVM.unarchiveChatUseCase(chat.id);
      }
    }

    setState(() {
      selectedChats.clear();
    });

    await contactVM.loadArchivedChats();
    await groupVM.loadArchivedChats();
  }

  @override
  Widget build(BuildContext context) {
    final contactState = ref.watch(chatContactViewModelProvider);
    final groupState = ref.watch(GroupArchivingViewModelProvider);

    if (contactState.isLoading || groupState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final archivedContacts = contactState.contacts;
    final archivedGroups = groupState.archivedGroups;

    final allArchivedChats = [
      ...archivedContacts.map((c) => SelectedChat(id: c.contactId, isGroup: false)),
      ...archivedGroups.map((g) => SelectedChat(id: g!.groupId, isGroup: true)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived'),
        actions: [
          if (selectedChats.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.unarchive),
              onPressed: unarchiveSelectedChats,
              tooltip: 'Unarchive',
            )
        ],
      ),
      body: ListView.builder(
        itemCount: allArchivedChats.length,
        itemBuilder: (context, index) {
          final chat = allArchivedChats[index];
          final isSelected = selectedChats.contains(chat);

          final name = chat.isGroup
              ? groupState.archivedGroups.firstWhere((g) => g.groupId == chat.id).name
              : contactState.contacts.firstWhere((c) => c.contactId == chat.id).name;

          final lastMessage = chat.isGroup
              ? groupState.archivedGroups.firstWhere((g) => g.groupId == chat.id).lastMessage
              : contactState.contacts.firstWhere((c) => c.contactId == chat.id).lastMessage;

          final time = chat.isGroup
              ? DateTime.fromMillisecondsSinceEpoch(
              groupState.archivedGroups.firstWhere((g) => g.groupId == chat.id).timeSent)


              : contactState.contacts.firstWhere((c) => c.contactId == chat.id).time;

          final profileVisibilityAsync = chat.isGroup
              ? AsyncValue.data(true) // always show group icon
              : ref.watch(profilePhotoVisibilityProvider({
            'currentUserId': FirebaseAuth.instance.currentUser?.uid ?? '',
            'otherUserId': chat.id,
          }));

          return profileVisibilityAsync.when(
            data: (canViewPhoto) => GestureDetector(
              onLongPress: () => toggleSelection(chat),
              onTap: () {
                if (selectedChats.isNotEmpty) {
                  toggleSelection(chat);
                } else {
                  // Optionally open the chat here
                }
              },
              child: Container(
                color: isSelected ? Colors.blue.withOpacity(0.3) : null,
                child: ListTile(
                  leading: chat.isGroup
                      ? const Icon(Icons.group)
                      : CircleAvatar(
                    backgroundImage: canViewPhoto
                        ? NetworkImage(
                        contactState.contacts
                            .firstWhere((c) => c.contactId == chat.id)
                            .prof)
                        : null,
                    child: canViewPhoto ? null : const Icon(Icons.person, color: Colors.white),
                    backgroundColor: Colors.grey,
                  ),
                  title: Text(name),
                  subtitle: Text(lastMessage),
                  trailing: Text(
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => ListTile(
              title: Text(name),
              subtitle: Text(lastMessage),
              trailing: Text('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'),
              leading: const Icon(Icons.person),
            ),
          );
        },
      ),
    );
  }
}
