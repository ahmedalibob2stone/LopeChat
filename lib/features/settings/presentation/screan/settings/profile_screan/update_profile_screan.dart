import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../user/presentation/provider/vm/update_profile_view_model.dart';
import '../../../../../user/presentation/viewmodel/updateing_profile_viewmodel.dart';




class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _statusController = TextEditingController();
  File? _newProfileImage;

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(UpdateProfileViewModelProvider);
    final vm = ref.read(UpdateProfileViewModelProvider.notifier);

    if (state.user != null && _nameController.text.isEmpty && _statusController.text.isEmpty) {
      _nameController.text = state.user!.name;
      _statusController.text = state.user!.statu;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final name = _nameController.text.trim();
              final status = _statusController.text.trim();

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرجاء إدخال الاسم')),
                );
                return;
              }

              // تحديث الاسم
              await vm.updateUserName(name);
              await vm.updateUserStatu(status);
              if (_newProfileImage != null) {
                await vm.updateProfileImage(_newProfileImage);
              }

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم التحديث بنجاح')),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: state.status == UserInfoStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _newProfileImage != null
                        ? FileImage(_newProfileImage!)
                        : (state.user?.profile.isNotEmpty ?? false
                        ? NetworkImage(state.user!.profile)
                        : const AssetImage('assets/images/user.png')) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () async {
                        final pickedFile = await pickImageFromGallery(); // استبدل بوظيفتك
                        if (pickedFile != null) {
                          setState(() {
                            _newProfileImage = File(pickedFile.path);
                          });
                        }
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(
                labelText: 'الحالة',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<XFile?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }
}
