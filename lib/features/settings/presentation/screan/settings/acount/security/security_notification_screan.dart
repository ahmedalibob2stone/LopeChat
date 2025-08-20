import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/account/security/viewmodel/provider.dart';
import '../../../../viewmodel/acount/security/security_viewmodel.dart';

class SecurityNotificationsScreen extends ConsumerWidget {
  const SecurityNotificationsScreen({Key? key}) : super(key: key);

  Widget _buildFeatureRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(securitySettingsViewModelProvider);
    final vm = ref.read(securitySettingsViewModelProvider.notifier);

    final isLoading = state.status == SecurityNotificationStatus.loading;
    final isEnabled = state.isEnabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security notifications'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          const Center(child: Icon(Icons.lock, size: 80, color: Colors.teal)),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Your security code changes when you reinstall the app or change devices. This helps verify the security of your chats.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 30),
          _buildFeatureRow(Icons.message_outlined, 'Messages'),
          _buildFeatureRow(Icons.call_outlined, 'Calls'),
          _buildFeatureRow(Icons.photo_outlined, 'Photos'),
          _buildFeatureRow(Icons.insert_drive_file_outlined, 'Documents'),
          _buildFeatureRow(Icons.location_on_outlined, 'Location sharing'),
          _buildFeatureRow(Icons.stacked_line_chart_outlined, 'New statuses'),
          const SizedBox(height: 30),
          const Divider(thickness: 1),

          // Toggle with loading overlay
          IgnorePointer(
            ignoring: isLoading,
            child: SwitchListTile(
              title: const Text(
                'Show security notifications',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Receive notifications when a contact\'s security code changes.',
                style: TextStyle(fontSize: 13),
              ),
              value: isEnabled,
              onChanged: (val) => vm.toggleNotification(val),
              activeColor: Colors.teal,
              secondary: Icon(
                isEnabled ? Icons.lock_open : Icons.lock_outline,
                color: Colors.teal,
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: Colors.teal),
              ),
            ),
          if (state.status == SecurityNotificationStatus.error)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Security notifications help you verify that your conversations are end-to-end encrypted and secure.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
