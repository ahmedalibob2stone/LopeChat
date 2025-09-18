import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/widgets/Buttom_container.dart';
import '../../../../common/widgets/helper snackbar/helper_snackbar.dart';
import '../../../../constant.dart';
import '../provider/vm/profile_view_model.dart';
import '../viewmodel/updateing_profile_viewmodel.dart';

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
  bool _isImageLoading = false;
  bool _isNextLoading = false;
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
      _pickedImage = picked;
      try {
        await ref.read(UserInfoViewModelProvider.notifier).updateProfileImage(picked);
      } catch (e) {
        AppSnackbar.showError(context, e.toString());
      }
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


    try {
      await ref.read(UserInfoViewModelProvider.notifier).saveUserData(
        name: name,
        profile: profile,
        statu: status,
      );

{
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            PageConst.MobileScreenLayout,
                (route) => false,
          );
        }
      }
    } catch (_) {
      // الأخطاء تم عرضها عبر listen بالفعل
    } finally {

    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(UserInfoViewModelProvider, (previous, next) {
      if (next.nameError != null) {
        AppSnackbar.showError(context, next.nameError!);
      } else if (next.statusError != null) {
        AppSnackbar.showError(context, next.statusError!);
      } else if (next.imageError != null) {
        AppSnackbar.showError(context, next.imageError!);
      }
    });

    final screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        automaticallyImplyLeading: true, // حذف أي أزرار الحفظ
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final profileState = ref.watch(UserInfoViewModelProvider);
          final double avatarRadius = MediaQuery.of(context).size.width * 0.15;

          final ImageProvider? bgImage = _pickedImage != null
              ? FileImage(File(_pickedImage!.path))
              : (profileState.user?.profile != null && profileState.user!.profile!.isNotEmpty
              ? NetworkImage(profileState.user!.profile!)
              : null);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
              SizedBox(
              height: avatarRadius * 2,
              width: avatarRadius * 2,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Colors.grey[300],
                    // cast آمن لتفادي مشكلة الأنواع الجنيريك
                    backgroundImage: bgImage as ImageProvider<Object>?,
                    child: bgImage == null
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),

                  if (profileState.isImageLoading)
                    Positioned.fill(
                      child: Container(
                        alignment: Alignment.center,
                        // color: Colors.black26,
                        child: const SizedBox(
                          height: 36,
                          width: 36,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                      ),
                    ),

                  Positioned(
                    right: 0,
                    bottom: 5,
                    child: InkWell(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        radius: 17,
                        backgroundColor: kkPrimaryColor,
                        child: Icon(Icons.add_a_photo, color: Colors.white, size: 19),
                      ),
                    ),
                  ),
                ],
              ),
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
                      icon: const Icon(Icons.edit, color: kkPrimaryColor),
                      onPressed: _updateStatus,
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          profileState.isNextLoading
          ? const Center(child: CircularProgressIndicator())
              : ButtonContainerWidget(
          color: kkPrimaryColor,
          text: 'Next',
          onTapListener: _handleNext,
          )

          ],

          )
          );




        },
      )
    );
  }
}
