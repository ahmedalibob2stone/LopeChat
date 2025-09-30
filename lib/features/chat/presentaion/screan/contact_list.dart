  import 'package:cached_network_image/cached_network_image.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:intl/intl.dart';

  import '../../../../common/selected_chat.dart';
  import '../../../../constant.dart';

  import '../../../contact/presentation/provider/vm/get_app_contact_viewmodel_provider.dart';
  import '../../../settings/presentation/provider/privacy/profile/vm/provider.dart';
  import '../../../user/presentation/provider/user_provider.dart';
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
        isSelectionMode = widget.selectedContacts.isNotEmpty;
      });
    }

    void _clearSelection() {
      setState(() {
        widget.selectedContacts.clear();
        isSelectionMode = false;
      });
    }

    void _archiveSelectedChats() async {
      final contactViewModel = ref.read(archiveChatContactViewModelProvider.notifier);
      final groupViewModel = ref.read(GroupArchivingViewModelProvider.notifier);

      final futures = widget.selectedContacts.map((chat) async {
        final isGroup = ref.read(chatGroupViewModelProvider).groups.any((g) => g.groupId == chat.id);
        if (isGroup) {
          await groupViewModel.archiveGroup(chat.id);
        } else {
          await contactViewModel.archiveChat(chat.id);
        }
      });

      await Future.wait(futures);

      await contactViewModel.loadUnarchivedChats();
      await contactViewModel.loadArchivedChats();

      _clearSelection();


    }

    void _deleteSelectedChats() async {
      final contactViewModel = ref.read(deleteChatViewModelProvider.notifier);
      final groupViewModel = ref.read(deleteGroupChatMessagesViewModelProvider.notifier);
      final groupList = ref.read(groupListViewModelProvider).groups;

      for (var receiver in widget.selectedContacts) {
        final isGroup = groupList.any((g) => g.groupId == receiver.id);

        if (isGroup) {
          await groupViewModel.deleteGroupChat(receiver.id);
        } else {
          await contactViewModel.deleteChat(receiverId: receiver.id);
        }
      }



      _clearSelection();
    }

    @override
    void initState() {
      super.initState();

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final currentUser = ref.read(cachedCurrentUserProvider.notifier).state;
        if (currentUser != null) {
          ref.read(chatContactViewModelProvider.notifier).loadChats(userId: currentUser.uid);
        }

        if (widget.searchName.isNotEmpty) {
          if (widget.isShowUser) {
            ref.read(searchChatViewModelProvider.notifier).searchContacts(widget.searchName);
          } else {
            ref.read(chatGroupViewModelProvider.notifier).searchGroups(widget.searchName);
          }
        } else {
          ref.read(archiveChatContactViewModelProvider.notifier).loadUnarchivedChats();
          ref.read(GroupArchivingViewModelProvider.notifier).loadUnarchivedGroup();
          ref.read(groupListViewModelProvider.notifier).getChatGroups();
        }
      });

      Future.microtask(() async {
        Future.microtask(() async {
          if (!mounted) return; // <-- تحقق أولاً
          await ref.read(getAppContactsViewModelProvider.notifier).loadAppContacts();

          if (!mounted) return;
          final contacts = ref.read(getAppContactsViewModelProvider).contacts;

          if (!mounted) return;
          await ref.read(profilePrivacyProvider.notifier).loadData(contacts);
        });

      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: isSelectionMode
              ? AppBar(
            backgroundColor: Colors.white.withOpacity(0.9), // شبه شفاف
            elevation: 1, // خفيف جدا
            automaticallyImplyLeading: false, // إزالة زر العودة الافتراضي
            titleSpacing: 0,
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.black87),
                  onPressed: _clearSelection,
                ),
                const SizedBox(width: 8),
                Text(
                  "${widget.selectedContacts.length} selected",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.volume_off),
                onPressed: _clearSelection,
                tooltip: "Pin",
              ),
              IconButton(
                icon: const Icon(Icons.push_pin),
                onPressed: _clearSelection,
                tooltip: "Pin",
              ),
              IconButton(
                icon: const Icon(Icons.archive, size: 20, color: Colors.black54),
                onPressed: _archiveSelectedChats,
                tooltip: 'Archive',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
                onPressed: _deleteSelectedChats,
                tooltip: 'Delete',
              ),

              const SizedBox(width: 4),
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

            // دمج المحادثات الفردية والجماعية
            final contactState = ref.watch(archiveChatContactViewModelProvider);
            final groupState = ref.watch(chatGroupViewModelProvider);
            final currentUserId = ref.watch(cachedCurrentUserProvider.notifier).state?.uid;

            // قائمة كل العناصر
            List<dynamic> allChats = [];

            // أضف المحادثات الفردية
            if (contactState.contacts.isNotEmpty) {
              allChats.addAll(contactState.contacts.map((c) => {'type': 'user', 'data': c}));
            }

            // أضف المحادثات الجماعية
            if (groupState.groups.isNotEmpty) {
              allChats.addAll(groupState.groups.map((g) => {'type': 'group', 'data': g}));
            }

            if (allChats.isEmpty) {
              return const Center(child: Text('No chats available'));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 2.0),
              itemCount: allChats.length + 1, // +1 للأرشيف
              itemBuilder: (context, index) {
                if (index == 0) return archiveTile(context);

                final chatItem = allChats[index - 1];
                final type = chatItem['type'];
                final data = chatItem['data'];

                if (type == 'user') {
                  final chatContact = data;
                  final isSelected = widget.selectedContacts.contains(
                    SelectedChat(id: chatContact.contactId, isGroup: false),
                  );
                  final showUnreadCount = chatContact.unreadMessageCount > 0 &&
                      chatContact.receiverId == currentUserId;

                  return InkWell(
                    onLongPress: () => _toggleSelection(chatContact.contactId, false),
                    onTap: () {
                      if (isSelectionMode) {
                        _toggleSelection(chatContact.contactId, false);
                      } else if (currentUserId != null) {
                        ref.read(chatSeenViewModelProvider.notifier).markMessageAsSeen(
                          chatContact.contactId,
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
                          backgroundImage: chatContact.prof.isNotEmpty
                              ? CachedNetworkImageProvider(chatContact.prof)
                              : null,
                          child: chatContact.prof.isEmpty
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
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.Hm().format(chatContact.time),
                              style: TextStyle(fontSize: timeFontSize, color: Colors.black),
                            ),
                            if (showUnreadCount)
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: kkPrimaryColor,
                                child: Text(
                                  '${chatContact.unreadMessageCount}',
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  final groupData = data;
                  final isSelected = widget.selectedContacts.contains(
                    SelectedChat(id: groupData.groupId, isGroup: true),
                  );
                  final unreadCount = groupData.unreadMessageCount[currentUserId] ?? 0;

                  return InkWell(
                    onLongPress: () => _toggleSelection(groupData.groupId, true),
                    onTap: () {
                      if (isSelectionMode) {
                        _toggleSelection(groupData.groupId, true);
                      } else {
                        ref.read(chatGroupViewModelProvider.notifier).markGroupMessagesAsSeen(
                          groupId: groupData.groupId,
                          uid: currentUserId!,
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
                              DateFormat.Hm().format(
                                DateTime.fromMillisecondsSinceEpoch(groupData.timeSent),
                              ),
                              style: TextStyle(fontSize: timeFontSize),
                            ),
                            if (unreadCount > 0)
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: kkPrimaryColor,
                                child: Text('$unreadCount',
                                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      );
    }

    Widget archiveTile(BuildContext context) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 1.0),
        leading: const Icon(
          Icons.archive,
          size: 20,
          color: Colors.grey,
        ),
        title: const Text(
          "Archive",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () => Navigator.pushNamed(context, PageConst.archiveScreen),
      );
    }
  }

