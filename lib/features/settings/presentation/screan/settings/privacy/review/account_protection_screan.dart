import 'package:flutter/material.dart';

import '../../acount/email/email_screen.dart';
import '../../acount/twostep/two_step_verification_screen.dart';

class AccountProtectionScreen extends StatelessWidget {
  const AccountProtectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Protection'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Secure your account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Help protect your account by setting up additional security options.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Two-step verification
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Two-step verification'),
            subtitle: const Text(
              'Create a personal identification number that will be required when registering your phone number again on SynapseChat.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            trailing: const Icon(Icons.keyboard_backspace, size: 16),
            onTap: () {
              // Navigate to two-step verification settings
            },
          ),
          const Divider(),

          // Passkey
          ListTile(
            leading: const Icon(Icons.key_outlined),
            title: const Text('Passkey'),
            subtitle: const Text(
              'Sign in to SynapseChat using your fingerprint or passcode.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            trailing: const Icon(Icons.keyboard_backspace, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TwoStepVerificationScreen()),
              );
            },
          ),
          const Divider(),

          // Recovery email
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Account recovery email'),
            subtitle: const Text(
              'Add a trusted email address to help you access your account on SynapseChat.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            trailing: const Icon(Icons.keyboard_backspace, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditEmailScreen()),
              );
                  },
          ),
        ],
      ),
    );
  }
}
