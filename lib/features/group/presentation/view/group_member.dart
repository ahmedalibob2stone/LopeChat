import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../common/contact/provider/contacts_provider.dart';
import '../../../../../common/widgets/Error_Screan.dart';
import '../../../../../common/widgets/Loeading.dart';
import '../../../../../constant.dart';
import '../../../contact/presentation/provider/vm/get_app_contact_viewmodel_provider.dart';

import '../../../user/presentation/provider/stream_provider/get_user_data_stream_provider.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../../../user/presentation/provider/stream_provider/user_data_provider.dart';
import '../provider/viewmodel/provider.dart';
import '../../../settings/presentation/provider/privacy/profile/vm/provider.dart';
final selectedUser = StateProvider<List<Contact>>((ref) => []);

class GroupMember extends ConsumerStatefulWidget {
  final String groupId;
  const GroupMember({Key? key, required this.groupId}) : super(key: key);

  @override
  ConsumerState<GroupMember> createState() => _GroupMemberState();
}

class _GroupMemberState extends ConsumerState<GroupMember> {
  Set<int> selectedContactsIndex = {};
  File? selectedImage;
  final TextEditingController _nameController = TextEditingController();

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
      ref.read(selectedUser.notifier).update(
            (state) => state.where((c) => c != contact).toList(),
      );
    } else {
      selectedContactsIndex.add(index);
      ref.read(selectedUser.notifier).update((state) => [...state, contact]);
    }
    setState(() {});
  }

  Future<void> addNewUser() async {
    final selectedContacts = ref.read(selectedUser);
    if (selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one contact')),
      );
      return;
    }

    await ref
        .read(groupProfileViewModelProvider.notifier)
        .addMembers(selectedContacts, widget.groupId);

    ref.read(selectedUser.notifier).state = [];
    selectedContactsIndex.clear();
    setState(() {});
  }

  Future<void> removeUser(String memberId) async {
    await ref
        .read(groupProfileViewModelProvider.notifier)
        .removeMember(widget.groupId, memberId);
  }

  Future<void> addAdmin(String userId) async {
    await ref.read(groupProfileViewModelProvider.notifier).addAdmin(widget.groupId, userId);
  }

  Future<void> removeAdmin(String userId) async {
    await ref.read(groupProfileViewModelProvider.notifier).removeAdmin(widget.groupId, userId);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(groupInformationViewModelProvider(widget.groupId).notifier).loadGroupInfo(widget.groupId);
    });
    Future.microtask(() async {
      await ref.read(getAppContactsViewModelProvider.notifier).loadAppContacts();
      final contacts = ref.read(getAppContactsViewModelProvider).contacts;
      await ref.read(profilePrivacyProvider.notifier).loadData(contacts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFont = screenWidth * 0.05;
    final double subTitleFont = screenWidth * 0.03;

    final currentUser = ref.watch(currentUserStreamProvider).value;
    final currentUserId = currentUser?.uid;

    final groupState = ref.watch(groupInformationViewModelProvider(widget.groupId));

    if (groupState.isLoading) {
      return const Loeading();
    } else if (groupState.errorMessage != null) {
      return ErrorScreen(error: groupState.errorMessage!);
    } else if (groupState.group != null) {
      final group = groupState.group!;
      final isOwner = currentUserId == group.ownerUid;
      final isAdmin = group.adminUids.contains(currentUserId);

      return Scaffold(
        appBar: AppBar(
          backgroundColor: kkPrimaryColor,
          leading: const BackButton(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Group Members', style: TextStyle(color: Colors.white, fontSize: titleFont)),
              const SizedBox(height: 3),
              Text('Manage members & admins', style: TextStyle(fontSize: subTitleFont)),
            ],
          ),
          actions: [
            if (isAdmin || isOwner)
              IconButton(
                icon: const Icon(Icons.group_add, color: Colors.white),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => buildAddMembersSheet(),
                ),
              ),
            if (!isOwner)
              IconButton(
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () => _confirmLeaveGroup(context),
              ),
            if (isAdmin || isOwner)
              IconButton(
                icon: const Icon(Icons.group_add, color: Colors.white),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => buildAddMembersSheet(),
                ),
              ),
          ],
        ),
        body: ListView.builder(
          itemCount: group.membersUid.length,
          itemBuilder: (context, index) {
            final memberId = group.membersUid[index];

            return ref.watch(userByIdStreamProvider(memberId)).when(
              loading: () => const ListTile(title: Text("...")),
              error: (e, _) => ListTile(title: Text("Error: $e")),
              data: (user) {
                final isMemberOwner = user.uid == group.ownerUid;
                final isMemberAdmin = group.adminUids.contains(user.uid);


                final currentUser = ref.watch(currentUserStreamProvider).asData?.value;
                final currentUserId = currentUser?.uid;

                final ownerContactUids = <String>[];

                final profilePrivacyforuse = ref.watch(profilePrivacyForUserProvider(user.uid).notifier);

                final canViewPhoto = (currentUserId != null)
                    ? profilePrivacyforuse.canSeeProfilePhoto(
                  profileOwnerUid: user.uid,
                  viewerUid: currentUserId,
                  ownerContactUids: ownerContactUids,
                )
                    : false;


                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: canViewPhoto && user.profile.isNotEmpty
                        ? NetworkImage(user.profile)
                        : null,
                    child: !canViewPhoto ? const Icon(Icons.lock) : null,
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.phoneNumber),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isMemberOwner)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('owner', style: TextStyle(color: Colors.white)),
                        )
                      else if (isMemberAdmin)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('admin', style: TextStyle(color: Colors.white)),
                        ),
                      const SizedBox(width: 10),
                      if (isOwner && !isMemberOwner)
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'addAdmin') await addAdmin(user.uid);
                            if (value == 'removeAdmin') await removeAdmin(user.uid);
                            if (value == 'removeMember') await removeUser(user.uid);
                          },
                          itemBuilder: (context) => [
                            if (!isMemberAdmin)
                              const PopupMenuItem(
                                value: 'addAdmin',
                                child: Text('Make Admin'),
                              ),
                            if (isMemberAdmin)
                              const PopupMenuItem(
                                value: 'removeAdmin',
                                child: Text('Remove Admin'),
                              ),
                            const PopupMenuItem(
                              value: 'removeMember',
                              child: Text('Remove Member'),
                            ),
                          ],
                        )
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      return const ErrorScreen(error: "Something went wrong");
    }
  }

  Widget buildAddMembersSheet() {
    final contactListAsync = ref.watch(getContactsProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: contactListAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorScreen(error: e.toString()),
          data: (contactList) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Select contacts to add", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: contactList.length,
                    itemBuilder: (context, index) {
                      final contact = contactList[index];
                      final isSelected = selectedContactsIndex.contains(index);

                      return InkWell(
                        onTap: () => selectContact(index, contact),
                        child: ListTile(
                          title: Text(contact.displayName),
                          leading: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : const Icon(Icons.radio_button_unchecked),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: addNewUser,
                  icon: const Icon(Icons.check),
                  label: const Text("Add Selected Members"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmLeaveGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave Group'),
        content: const Text('Are you sure you want to leave this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // close dialog
              await ref
                  .read(leaveGroupViewModelProvider.notifier)
                  .leaveGroup(widget.groupId);

              if (context.mounted) {
                Navigator.pop(context); // Exit GroupMember screen
              }
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      setState(() {});
    }
  }

  void showEditGroupDialog(String groupId, String currentName) {
    _nameController.text = currentName;

    showDialog(
      context: context,
      builder: (context) {
        final updateState = ref.watch(updateGroupInfoViewModelProvider);

        return AlertDialog(
          title: const Text('Edit Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Group Name'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Choose New Image'),
              ),
              if (selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Image.file(selectedImage!, height: 80),
                ),
            ],
          ),
          actions: [
            if (updateState.isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await ref.read(updateGroupInfoViewModelProvider.notifier).updateGroupInfo(
                    groupId: groupId,
                    newName: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
                    newProfileImage: selectedImage,
                  );
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ]
          ],
        );
      },
    );
  }
}
