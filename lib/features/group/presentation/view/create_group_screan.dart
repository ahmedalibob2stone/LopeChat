import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/utils/utills.dart';
import '../../../../common/widgets/contact_count_widget.dart';
import '../../../../constant.dart';
import '../../../contact/presentation/provider/vm/get_all_app_contact_viewmodel_provider.dart.dart';
import '../../../settings/presentation/provider/privacy/group/vm/viewmodel_provider.dart';
import '../provider/viewmodel/provider.dart';
import '../viewmodel/create_group_viewmodel.dart';
import 'group_screan.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  File? image;
  final TextEditingController groupController = TextEditingController();

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void pickPhoto() async {
    image = await tackImage(context);
    setState(() {});
  }

  void createGroup() {
    final name = groupController.text.trim();
    final contacts = ref.read(selectedGroupContacts);

    final groupPrivacyState = ref.read(groupPrivacyViewModelProvider);

    bool canAdd = true;
    String? blockedMessage;

    switch (groupPrivacyState.selectedVisibility) {
      case 'everyone':
        canAdd = true;
        break;
      case 'contacts':
        final notInContacts = contacts.where(
              (c) => !groupPrivacyState.filteredContacts.map((e) => e.uid).contains(c.id),
        ).toList();
        if (notInContacts.isNotEmpty) {
          canAdd = false;
          blockedMessage =
          '${notInContacts.first.name} Not in your contacts and cannot be added';
        }
        break;
      case 'contactsExcept':
        final blocked = contacts.where(
              (c) => groupPrivacyState.excludedUids.contains(c.id),
        ).toList();
        if (blocked.isNotEmpty) {
          canAdd = false;
          blockedMessage =
          '${blocked.first.name} Already in the exceptions list and cannot be added';
        }
        break;
      default:
        canAdd = true;
    }

    if (!canAdd) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(blockedMessage ?? 'You cannot add this contact')),
      );
      return; // منع إنشاء الجروب
    }

    if (name.isNotEmpty && image != null && contacts.isNotEmpty) {
      ref.read(CreateGroupViewModelProvider.notifier).createGroup(
        name,
        image!,
        contacts,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a group name, select an image and contacts',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(CreateGroupViewModelProvider);

    // الاستماع لتغييرات الحالة
    ref.listen<GroupState>(CreateGroupViewModelProvider, (previous, next) {
      if (next.status == GroupStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message ?? 'Group created successfully')),
        );
        Navigator.pop(context);
      } else if (next.status == GroupStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.message}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kkPrimaryColor,
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Group',
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            ContactsCountWidget()
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, size: MediaQuery.of(context).size.width * 0.07),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: image == null
                        ? const NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg')
                        : FileImage(image!) as ImageProvider,
                    radius: 80,
                  ),
                  Positioned(
                    bottom: 10,
                    left: 110,
                    child: IconButton(
                      onPressed: () => displayModalBottomSheet(context),
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(0),
              ),
              child: TextFormField(
                controller: groupController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  icon: Icon(Icons.group),
                  hintText: " Enter Group Name",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Select Contacts',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            const Divider(),
            const SelectContactsGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kkPrimaryColor,
        onPressed: groupState.status == GroupStatus.loading ? null : createGroup,
        child: groupState.status == GroupStatus.loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.done, color: Colors.white),
      ),
    );
  }

  void displayModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                pickPhoto();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album_outlined),
              title: const Text('Gallery'),
              onTap: () {
                selectImage();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
