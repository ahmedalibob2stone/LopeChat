import 'package:flutter/material.dart';

import '../app lock/app_lock_screan.dart';
import '../auto disappear screan/auto_disappear_sscrean.dart';

class AddBigPrivacyToYourChats extends StatelessWidget {
  const AddBigPrivacyToYourChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'More privacy for your chats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'To enjoy more privacy, you can restrict access to your messages and media using these privacy features.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),

          // App Lock
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('App Lock'),
            subtitle: const Text(
              'You\'ll need your fingerprint or face to open WhatsApp on your device.',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.keyboard_backspace, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppLockMainScreen()),
              );
            },
          ),
          const Divider(),

          // Default Message Timer
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: const Text('Default Message Timer'),
            subtitle: const Text(
              'Start new chats with disappearing messages. You can control the duration of your visibility using the timer.',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.keyboard_backspace, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AutoDisappearSettingsScreen()),
              );
            },
          ),
          const Divider(),

          // End-to-End Encrypted Backups
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('End-to-end Encrypted Backups'),
            subtitle: const Text(
              'You can encrypt your backup so that no one—not even Google—can access it.',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.keyboard_backspace, size: 16),
            onTap: () {
              // Navigate to Backup Encryption settings
            },
          ),
        ],
      ),
    );
  }
}
