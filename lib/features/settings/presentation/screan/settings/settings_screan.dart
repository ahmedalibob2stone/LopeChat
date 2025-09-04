  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  import '../../../../../constant.dart';
import '../../../../user/presentation/provider/stream_provider/stream_providers.dart';

  class SettingsScreen extends ConsumerWidget {
    const SettingsScreen({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context,WidgetRef ref) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.grey[100],
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 16),
            _buildUserHeader(context,ref ),
            const Divider(),
            _buildSectionLabel(context,'Account', Icons.key),
            _buildSettingTile(context, 'Privacy', Icons.lock),
            _buildSettingTile(context, 'Security', Icons.security),
            _buildSettingTile(context, 'Two-step verification', Icons.verified_user),
            _buildSettingTile(context, 'Change number', Icons.swap_horiz),
            _buildSettingTile(context, 'Request account info', Icons.info_outline),
            const Divider(),
            _buildSettingTile(context, 'Avatar', Icons.emoji_emotions_outlined),
            _buildSettingTile(context, 'Chats', Icons.chat_bubble_outline),
            _buildSettingTile(context, 'Notifications', Icons.notifications_none),
            _buildSettingTile(context, 'Storage and data', Icons.sd_storage),
            const Divider(),
            _buildSettingTile(context, 'App language', Icons.language),
            _buildSettingTile(context, 'Help', Icons.help_outline),
            _buildSettingTile(context, 'Invite a friend', Icons.group_add_outlined),
          ],
        ),
      );
    }

    Widget _buildUserHeader(BuildContext context, ref) {
      final userAsync = ref.watch(currentUserStreamProvider);

      return userAsync.when(
        data: (user) {
          if (user == null) {
            return const Text('لم يتم العثور على بيانات المستخدم');
          }

          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(PageConst.Edit_Profile);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: user.profile.isNotEmpty
                        ? NetworkImage(user.profile)
                        : const AssetImage('assets/images/user.png') ,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(user.statu, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const Icon(Icons.qr_code, color: Colors.teal),
                ],
              ),
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('خطأ: $err'),
        ),
      );
    }

    Widget _buildSectionLabel(BuildContext context,String title, IconData icon) {
      return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(PageConst.AccountDetailsScreen);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Security notifications, change number',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }


    Widget _buildSettingTile(BuildContext context, String title, IconData icon) {
      return ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {

         },
      );
    }



  }
