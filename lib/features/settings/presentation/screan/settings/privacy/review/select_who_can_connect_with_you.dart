
import 'package:flutter/material.dart';

import '../block/blocked_users_screan.dart';
import '../call/privacy_calls_screan.dart';
import '../group/group_privacy_screan.dart';

class  ChooseWhoCanContactWithYou extends StatelessWidget {
  const ChooseWhoCanContactWithYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Select who can connect with you'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Center(
              child: Icon(Icons.privacy_tip, size: 80, color: Colors.black),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                ' Choose who can contact you',
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
                ' You can control your privacy choose who can contact you and block unwanted calls or messages',
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
              leading: const Icon(Icons.group),
              title: const Text('Groups'),
              subtitle: const Text(
                'Decide whether anyone or only contacts can add you to groups.',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.keyboard_backspace, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GroupPrivacyScreen()),
                );
                //
              },
            ),

            const Divider(),

            // Call blocking
            ListTile(
              leading: const Icon(Icons.volume_off),
              title: const Text('Silence Unknown Callers'),
              subtitle: const Text(
                'Block calls from numbers not in your contacts.',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.keyboard_backspace, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyCallsScreen()),
                );
              },
            ),

            const Divider(),

            // Blocked Contacts
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Blocked Contacts'),
              subtitle: const Text(
                'See and manage the list of blocked contacts.',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.keyboard_backspace, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BlockedUsersScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
