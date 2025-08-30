import 'package:flutter/material.dart';

import '../../profile_screan/update_profile_screan.dart';
import '../last seen and online/last_seen_and_online_screan.dart';
import '../privacy_screan.dart';

class ControlInMyPrivateInformation extends StatelessWidget {
  const ControlInMyPrivateInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Review Privacy Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Center(
              child: Icon(Icons.search, size: 80, color: Colors.black),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Control your privacy settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                ' Choose who can see your personal info like your “Online” status and activity',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Groups
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile '),
              subtitle: const Text(
                ' Choose who can see your profile photo.',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.keyboard_backspace, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),

            const Divider(),

            // Call blocking
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Last seen and Online'),
              subtitle: const Text(
                ' Choose who can see your “Online” status',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.keyboard_backspace, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LastSeenAndOnlineScreen()),
                );
              },
            ),

            const Divider(),

            // Blocked Contacts
            ListTile(
              leading: const Icon(Icons.done_all),
              title: const Text('Read Receipts'),
              subtitle: const Text(
                ' When this setting is enabled, others will see that you’ve read their messages',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.keyboard_backspace, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyScreen(initialSection: 'read_receipts')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
