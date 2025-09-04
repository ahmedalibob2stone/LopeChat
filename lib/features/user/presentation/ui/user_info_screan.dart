import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/widgets/Buttom_container.dart';
import '../../../../constant.dart';
import '../provider/vm/profile_view_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _statusController = TextEditingController();
  XFile? _pickedImage;
  bool _isSavingName = false;
  bool _isSavingStatus = false;

  @override
  void initState() {
    super.initState();
    final profileState = ref.read(UserInfoViewModelProvider);
    _nameController.text = profileState.user?.name ?? '';
    _statusController.text = profileState.user?.statu ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
      });
      await ref
          .read(UserInfoViewModelProvider.notifier)
          .updateProfileImage(picked);
    }
  }

  Future<void> _updateName() async {
    setState(() {
      _isSavingName = true;
    });
    await ref
        .read(UserInfoViewModelProvider.notifier)
        .updateName(_nameController.text.trim());
    setState(() {
      _isSavingName = false;
    });
  }

  Future<void> _updateStatus() async {
    setState(() {
      _isSavingStatus = true;
    });
    await ref
        .read(UserInfoViewModelProvider.notifier)
        .updateStatus(_statusController.text.trim());
    setState(() {
      _isSavingStatus = false;
    });
  }

  Future<void> _handleNext() async {
    final name = _nameController.text.trim();
    final status = _statusController.text.trim();
    final profile = _pickedImage != null ? File(_pickedImage!.path) : null;

    if (name.isEmpty || status.isEmpty || profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    await ref.read(UserInfoViewModelProvider.notifier).saveUserData(
      name: name,
      profile: profile,
      statu: status,
    );

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        PageConst.mobileChatScrean,
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(UserInfoViewModelProvider, (previous, next) {
      if (next.nameError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.nameError!)),
        );

      } else if (next.statusError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.statusError!)),
        );
      } else if (next.imageError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.imageError!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        automaticallyImplyLeading: true, // حذف أي أزرار الحفظ
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile image
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _pickedImage != null
                      ? FileImage(File(_pickedImage!.path))
                      : ref.read(UserInfoViewModelProvider).user?.profile != null
                      ? NetworkImage(ref.read(UserInfoViewModelProvider).user!.profile)
                      : null as ImageProvider<Object>?,
                  child: (_pickedImage == null &&
                      ref.read(UserInfoViewModelProvider).user?.profile == null)
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
                Positioned(
                  bottom: 5,
                  right: 0,
                  child: InkWell(
                    onTap: _pickImage,
                    child: const CircleAvatar(

                      radius: 17,
                      backgroundColor: kkPrimaryColor,
                      child: Icon(Icons.add_a_photo, color: Colors.white,size: 19,),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Name field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                _isSavingName
                    ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : IconButton(
                  icon: const Icon(Icons.edit, color: kkPrimaryColor),
                  onPressed: _updateName,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Status field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _statusController,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                _isSavingStatus
                    ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : IconButton(
                  icon: const Icon(Icons.edit, color:kkPrimaryColor),
                  onPressed: _updateStatus,
                ),
              ],
            ),
            const SizedBox(height: 100),

            // Next button
            ButtonContainerWidget(
              color: kkPrimaryColor,
              text: 'Next',
              onTapListener: _handleNext,
            ),
          ],
        ),
      ),
    );
  }
}
