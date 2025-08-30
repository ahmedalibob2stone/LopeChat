import 'package:lopechat/features/settings/presentation/screan/settings/privacy/review/select_who_can_connect_with_you.dart';
import 'package:flutter/material.dart';

import 'account_protection_screan.dart';
import 'add_big_privacy_to _your _chats.dart';
import 'control_in_my_private_information.dart';

class PrivacySettingsReviewScreen extends StatelessWidget {
  const PrivacySettingsReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings Review'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.privacy_tip_outlined,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Privacy Matters',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Control your privacy settings with SynapseChat the way you want',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.call),
                      title: const Text('Choose who can contact you'),
                      trailing: const Icon(Icons.keyboard_backspace),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ChooseWhoCanContactWithYou()),
                        );                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Manage your personal info'),
                      trailing: const Icon(Icons.keyboard_backspace),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ControlInMyPrivateInformation()),
                        );
                        // ControlInMyPrivateInformation
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat),
                      title: const Text('Add more privacy to your chats'),
                      trailing: const Icon(Icons.keyboard_backspace),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddBigPrivacyToYourChats()),
                        );                      },
                    ),
                    ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.lock),
                          SizedBox(width: 8),
                        ],
                      ),
                      title: const Text('Enhance your protection'),
                      trailing: const Icon(Icons.keyboard_backspace),
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AccountProtectionScreen()),
                        );                       },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
