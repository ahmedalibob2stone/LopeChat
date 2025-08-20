import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/privacy/profile/vm/provider.dart';
import '../../../../viewmodel/privacy/profile/privacy_profile_viewmodel.dart';
import 'excluded_contacts_profile_privacy_screan.dart';

class ProfilePhotoPrivacyScreen extends ConsumerWidget {
  const ProfilePhotoPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profilePrivacyProvider);
    final viewModel = ref.read(profilePrivacyProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("صورة الملف الشخصي")),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("من يمكنه رؤية صورة الملف الشخصي؟", style: TextStyle(fontSize: 16)),
          ),
          ...[
            ProfilePrivacyVisibility.everyone,
            ProfilePrivacyVisibility.myContacts,
            ProfilePrivacyVisibility.myContactsExcept,
            ProfilePrivacyVisibility.nobody,
          ].map((option) {
            final selected = state.profilePrivacy?.visibility == option;
            return ListTile(
              title: Text(_getOptionLabel(option)),
              trailing: selected
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.radio_button_unchecked),
              onTap: () {
                if (option == ProfilePrivacyVisibility.myContactsExcept) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExcludedContactsProfilePrivacyScreen()),
                  );
                } else {
                  viewModel.setProfilePhotoVisibility(option);
                }
              },
            );
          }),
          if (state.hasChanges)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await viewModel.saveChanges();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("تم حفظ التغييرات")),
                    );
                  }
                },
                child: const Text("حفظ التغييرات"),
              ),
            ),
        ],
      ),
    );
  }

  String _getOptionLabel(String value) {
    switch (value) {
      case ProfilePrivacyVisibility.everyone:
        return "everyone";
      case ProfilePrivacyVisibility.myContacts:
        return " my Contacts";
      case ProfilePrivacyVisibility.myContactsExcept:
        return "my Contacts Except";
      case ProfilePrivacyVisibility.nobody:
        return "nobody ";
      default:
        return value;
    }
  }
}
