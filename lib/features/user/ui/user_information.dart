import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../common/utils/utills.dart';
import '../../../common/widgets/Buttom_container.dart';
import '../../../common/widgets/Error_Screan.dart';
import '../../../common/widgets/Loeading.dart';
import '../../../constant.dart';
import '../../../responsive/mobile_screen_Layout.dart';
import '../provider/user_information_provider.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
   UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  File? image;
  bool _validateStatus = true;

  void selectImageFromGallery() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void selectImageFromCamera() async {
    image = await tackImage(context);
    setState(() {});
  }

  void showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Camera'),
            onTap: () {
              selectImageFromCamera();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Gallery'),
            onTap: () {
              selectImageFromGallery();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
  void handleSubmit() async {
    final name = nameController.text.trim();
    final status = statusController.text.trim();

    setState(() {
      _validateStatus = status.length >= 10;
    });

    if (name.isNotEmpty && _validateStatus && image != null) {
      await ref.read(userInformationViewModelProvider.notifier).saveUserInfo(

        name: name,
        statu: status,
        profile: image,
      );
      await ref.read(userInformationViewModelProvider.notifier).reloadUser();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MobileScreenLayout()),
            (route) => false,
      );
// بعدها نقرأ البيانات المحدثة من نفس الـ provider
      final newUser = ref.read(userInformationViewModelProvider).maybeWhen(
        data: (user) => user,
        orElse: () => null,
      );
      if (newUser != null &&
          newUser.name.isNotEmpty &&
          newUser.statu.isNotEmpty &&
          newUser.profile.isNotEmpty) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MobileScreenLayout()),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userInformationViewModelProvider);

    return userState.when(
      data: (user) {
        if (user != null &&
            user.name.isNotEmpty &&
            user.statu.isNotEmpty &&
            user.profile.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MobileScreenLayout()),
            );
          });
        }

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
                vertical: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Column(
                children: [
                  // Profile Picture
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.2,
                        backgroundImage: image != null
                            ? FileImage(image!)
                            : user?.profile != null
                            ? NetworkImage(user!.profile)
                            : const NetworkImage(
                          'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg',
                        ) as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: showImagePickerBottomSheet,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Name Input
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: user?.name ?? 'Enter your name',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Status Input
                  TextField(
                    controller: statusController,
                    decoration: InputDecoration(
                      hintText: user?.statu ?? 'Enter your status',
                      errorText: _validateStatus ? null : 'Status must be at least 10 characters',
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
                  ButtonContainerWidget(
                    color: kkPrimaryColor,
                    text: 'Next',
                    onTapListener: handleSubmit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Loeading(),
      error: (error, _) => ErrorScreen(error: error.toString()),
    );
  }
}
