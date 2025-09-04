import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../../../../common/widgets/Loeading.dart';
import '../../../../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../../../../provider/privacy/profile/vm/provider.dart';

class ExcludedContactsProfilePrivacyScreen extends ConsumerWidget {
  const ExcludedContactsProfilePrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profilePrivacyProvider);
    final viewModel = ref.read(profilePrivacyProvider.notifier);
    const double leadingRadius = 20.0;
    const double fontSize = 16.0;
    final contacts = viewModel.sortedContacts;

    final currentUser = ref.watch(currentUserStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Excluded Contacts'),
        actions: [
          if (contacts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: viewModel.toggleSelectAll,
            ),
        ],
      ),
      body: state.isLoading
          ? const Loeading()
          : ListView.separated(
        itemCount: contacts.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final user = contacts[index];
          final isExcluded = state.profilePrivacy?.exceptUids.contains(user.uid) ?? false;

          if (currentUserId.isEmpty) {
            // Without current user ID, do not show profile photo
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                radius: leadingRadius,
                child: const Icon(Icons.person, size: 32, color: Colors.white),
              ),
              title: Text(user.name),
              trailing: Icon(
                isExcluded ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isExcluded ? Colors.green : null,
              ),
              onTap: () => viewModel.toggleExcludedUid(user.uid),
            );
          }

          final profilePhotoVisibilityAsync = ref.watch(profilePhotoVisibilityProvider({
            'currentUserId': currentUserId,
            'otherUserId': user.uid,
          }));

          return profilePhotoVisibilityAsync.when(
            data: (canViewPhoto) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  radius: leadingRadius,
                  backgroundImage: canViewPhoto && user.profile.isNotEmpty
                      ? CachedNetworkImageProvider(user.profile)
                      : null,
                  child: !canViewPhoto || user.profile.isEmpty
                      ? const Icon(Icons.person, size: 32, color: Colors.white)
                      : null,
                ),
                title: Text(user.name),
                trailing: Icon(
                  isExcluded ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isExcluded ? Colors.green : null,
                ),
                onTap: () => viewModel.toggleExcludedUid(user.uid),
              );
            },
            loading: () => ListTile(
              leading: CircleAvatar(
                radius: leadingRadius,
                child: const CircularProgressIndicator(),
              ),
              title: Text(user.name),
            ),
            error: (error, stack) => ListTile(
              leading: CircleAvatar(
                radius: leadingRadius,
                child: const Icon(Icons.error, color: Colors.red),
              ),
              title: const Text('Error loading data'),
            ),
          );
        },
      ),
      floatingActionButton: state.hasChanges
          ? FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          await viewModel.saveChanges();
          if (context.mounted) Navigator.pop(context);
        },
      )
          : null,
    );
  }
}
