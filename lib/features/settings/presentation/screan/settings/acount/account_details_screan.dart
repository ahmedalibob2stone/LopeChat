import 'package:flutter/material.dart';

import '../../../../../../constant.dart';
import 'account manage/add_account_bottom_sheet.dart';
import 'email/email_screen.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, String title) {
    //AddAccountScreen
    Navigator.of(context).pushNamed(PageConst.SecurityNotificationsScreen);
    Navigator.of(context).pushNamed(PageConst.TwoStepVerificationScreen);
    Navigator.of(context).pushNamed(PageConst.ChangeNumberInfoScreen);
    Navigator.of(context).pushNamed(PageConst.AccountReportScreen);
    Navigator.of(context).pushNamed(PageConst.AddAccountScreen);
    Navigator.of(context).pushNamed(PageConst.DeleteAccountScreen);


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped: $title')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.teal,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back),
        ),
      ),

      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Security notifications'),
            onTap: () => _navigateTo(context, 'Security notifications'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email address'),
            onTap: () async {
              final updatedEmail =
              Navigator.of(context).pushNamed(PageConst.EditEmailScreen);

              if (updatedEmail != null) {
                // نفذ عملية الحفظ هنا، مثلاً استدعاء ViewModel أو تحديث الحالة
                print('تم حفظ البريد الإلكتروني: $updatedEmail');
              }
            },

          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Two-step verification'),
            onTap: () => _navigateTo(context, 'Two-step verification'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.phone_android),
            title: const Text('Change number'),
            onTap: () => _navigateTo(context, 'Change number'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.file_copy),
            title: const Text('Request account info'),
            onTap: () => _navigateTo(context, 'Request account info'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Add account'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                isScrollControlled: true,
                builder: (context) => const AddAccountBottomSheet(),
              );
            },

            //=> _navigateTo(context, 'Add account'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Delete account', style: TextStyle(color: Colors.red)),
            onTap: () => _navigateTo(context, 'Delete account'),
          ),
        ],
      ),
    );
  }
}
