import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../common/selected_chat.dart';
import '../../../../common/widgets/Loeading.dart';
import '../../../../constant.dart';

import '../../../contact/presentation/provider/vm/get_app_contact_viewmodel_provider.dart';
import '../../../settings/presentation/provider/privacy/profile/vm/provider.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../provider/chat_contact/viewmodel/provider.dart';
import '../provider/chat_group/viewmodel/provider.dart';
import '../provider/chat_massage/viewmodel/provider.dart';

class ContactList extends ConsumerStatefulWidget {
  const ContactList({
    Key? key,
    required this.searchName,
    required this.isShowUser,
    required this.selectedContacts,
    required this.toggleSelection,
  }) : super(key: key);

  final String searchName;
  final bool isShowUser;
  final Set<SelectedChat> selectedContacts;
  final void Function(String id, bool isGroup) toggleSelection;

  @override
  ConsumerState<ContactList> createState() => _ContactListState();
}

class _ContactListState extends ConsumerState<ContactList> {
  bool isSelectionMode = false;

  _toggleSelection(String id, bool isGroup) {
    final chat = SelectedChat(id: id, isGroup: isGroup);
    setState(() {
      if (widget.selectedContacts.contains(chat)) {
        widget.selectedContacts.remove(chat);
      } else {
        widget.selectedContacts.add(chat);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      widget.selectedContacts.clear();
      isSelectionMode = false;
    });
  }

  void _archiveSelectedChats() async {
    final contactViewModel = ref.read(chatContactViewModelProvider.notifier);
    final groupViewModel = ref.read(GroupArchivingViewModelProvider.notifier);

    for (var chat in widget.selectedContacts) {
      final isGroup = ref.read(chatGroupViewModelProvider).groups.any((g) => g.groupId == chat.id);
      if (isGroup) {
        await groupViewModel.archiveGroup(chat.id);
      } else {
        await contactViewModel.archiveChat(chat.id);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected chats archived successfully'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    _clearSelection();
  }

  void _deleteSelectedChats() async {
    final contactViewModel = ref.read(deleteChatViewModelProvider.notifier);
    final groupViewModel = ref.read(deleteGroupChatMessagesViewModelProvider.notifier);
    final groupState = ref.read(groupListViewModelProvider);
    final groupList = groupState.groups;

    for (var receiver in widget.selectedContacts) {
      final isGroup = groupList.any((g) => g.groupId == receiver.id);

      if (isGroup) {
        await groupViewModel.deleteGroupChat(receiver.id);
      } else {
        await contactViewModel.deleteChat(receiverId: receiver.id);
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected chats deleted successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }

    _clearSelection();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.searchName.isNotEmpty) {
        if (widget.isShowUser) {
          ref.read(searchChatViewModelProvider.notifier).searchContacts(widget.searchName);
        } else {
          ref.read(chatGroupViewModelProvider.notifier).searchGroups(widget.searchName);
        }
      } else {
        ref.read(chatContactViewModelProvider.notifier).loadUnarchivedChats();
        ref.read(GroupArchivingViewModelProvider.notifier).loadUnarchivedGroup();
        ref.read(groupListViewModelProvider.notifier).getChatGroups();
      }
    });

    Future.microtask(() async {
      await ref.read(getAppContactsViewModelProvider.notifier).loadAppContacts();
      final contacts = ref.read(getAppContactsViewModelProvider).contacts;
      await ref.read(profilePrivacyProvider.notifier).loadData(contacts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSelectionMode
          ? AppBar(
        title: Text("${widget.selectedContacts.length} selected"),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: _archiveSelectedChats,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteSelectedChats,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _clearSelection,
          ),
        ],
      )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final avatarRadius = isMobile ? 24.0 : 36.0;
          final titleFontSize = isMobile ? 16.0 : 22.0;
          final subtitleFontSize = isMobile ? 12.0 : 16.0;
          final timeFontSize = isMobile ? 11.0 : 14.0;

          return Padding(
            padding: EdgeInsets.only(top: isMobile ? 10.0 : 20.0),
            child: widget.isShowUser
                ? _buildUserList(avatarRadius, titleFontSize, subtitleFontSize, timeFontSize)
                : _buildGroupList(avatarRadius, titleFontSize, subtitleFontSize, timeFontSize),
          );
        },
      ),
    );
  }

  Widget _buildUserList(
      double avatarRadius,
      double titleFontSize,
      double subtitleFontSize,
      double timeFontSize,
      ) {
    final contactState = ref.watch(chatContactViewModelProvider);
    final currentUser = ref.watch(currentUserStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid;

    if (contactState.isLoading) return const Loeading();
    if (contactState.error != null) return Center(child: Text('Error: ${contactState.error}'));
    if (contactState.contacts.isEmpty) return const Center(child: Text('No contacts available'));

    // نستخدم ListView.builder مع AsyncValue لكل جهة اتصال
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.archive),
          title: const Text("Archive"),
          onTap: () => Navigator.pushNamed(context, PageConst.archiveScreen),
        ),
        ...contactState.contacts.map((chatContact) {
          final isSelected = widget.selectedContacts.contains(
            SelectedChat(id: chatContact.contactId, isGroup: false),
          );

          final profileVisibilityAsync = currentUserId != null
              ? ref.watch(profilePhotoVisibilityProvider({
            'currentUserId': currentUserId,
            'otherUserId': chatContact.contactId,
          }))
              : AsyncValue.data(false);

          return profileVisibilityAsync.when(
            data: (showProfilePhoto) {
              return InkWell(
                onLongPress: () => _toggleSelection(chatContact.contactId, false),
                onTap: () {
                  if (isSelectionMode) {
                    _toggleSelection(chatContact.contactId, false);
                  } else {
                    ref.read(chatSeenViewModelProvider.notifier).markMessageAsSeen(
                      currentUserId!,

                    );
                    Navigator.pushNamed(
                      context,
                      PageConst.mobileChatScrean,
                      arguments: {
                        'name': chatContact.name,
                        'uid': chatContact.contactId,
                        'isGroupChat': false,
                        'profilePic': chatContact.prof,
                      },
                    );
                  }
                },
                child: Container(
                  color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      radius: avatarRadius,
                      backgroundImage: showProfilePhoto
                          ? CachedNetworkImageProvider(chatContact.prof)
                          : null,
                      child: !showProfilePhoto
                          ? const Icon(Icons.person, size: 30, color: Colors.white)
                          : null,
                    ),
                    title: Text(chatContact.name, style: TextStyle(fontSize: titleFontSize)),
                    subtitle: Text(
                      chatContact.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: subtitleFontSize),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        DateFormat.Hm().format(chatContact.time),
                        style: TextStyle(fontSize: timeFontSize, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
            error: (_, __) => const SizedBox.shrink(),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildGroupList(double avatarRadius, double titleFontSize, double subtitleFontSize, double timeFontSize) {
    final groupState = ref.watch(chatGroupViewModelProvider);

    if (groupState.isUpdatingGroupChat || groupState.isLoading) return const Loeading();
    if (groupState.error != null) return Center(child: Text('Error: ${groupState.error}'));
    if (groupState.groups.isEmpty) return const Center(child: Text('No groups available'));

    return ListView.builder(
      itemCount: groupState.groups.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            leading: const Icon(Icons.archive),
            title: const Text("Archive"),
            onTap: () => Navigator.pushNamed(context, PageConst.archiveScreen),
          );
        }

        final groupData = groupState.groups[index - 1];
        final isSelected = widget.selectedContacts.contains(groupData.groupId);

        final unreadCount = groupData.unreadMessageCount[FirebaseAuth.instance.currentUser!.uid] ?? 0;

        return InkWell(
          onLongPress: () => _toggleSelection(groupData.groupId,true),
          onTap: () {
            if (isSelectionMode) {
              _toggleSelection(groupData.groupId,true);
            } else {
              final uid = FirebaseAuth.instance.currentUser!.uid;
              ref.read(chatGroupViewModelProvider.notifier).markGroupMessagesAsSeen(
                groupId: groupData.groupId,
                uid: uid,
              );
              ref.read(chatGroupViewModelProvider.notifier).openGroupChat(groupData.groupId);
              Navigator.pushNamed(
                context,
                PageConst.mobileChatScrean,
                arguments: {
                  'name': groupData.name,
                  'uid': groupData.groupId,
                  'isGroupChat': true,
                  'profilePic': groupData.groupPic,
                },
              );
            }
          },
          child: Container(
            color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.transparent,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.3),
                radius: avatarRadius,
                backgroundImage: groupData.groupPic.isNotEmpty
                    ? CachedNetworkImageProvider(groupData.groupPic)
                    : null,
                child: groupData.groupPic.isEmpty
                    ? const Icon(Icons.group, size: 30, color: Colors.white)
                    : null,
              ),
              title: Text(groupData.name, style: TextStyle(fontSize: titleFontSize)),
              subtitle: Text(
                groupData.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: subtitleFontSize),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(groupData.timeSent)),
                    style: TextStyle(fontSize: timeFontSize),
                  ),
                  if (unreadCount > 0)
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: kkPrimaryColor,
                      child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
