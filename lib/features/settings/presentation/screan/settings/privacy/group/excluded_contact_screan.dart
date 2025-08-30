import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../../../../common/widgets/Loeading.dart';
import '../../../../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../../../user/domain/entities/user_entity.dart';
import '../../../../../../user/provider/get_userdata_provider.dart';
import '../../../../provider/privacy/group/vm/viewmodel_provider.dart';
import '../../../../viewmodel/privacy/group/group_privacy_viewmodel.dart';

class ExcludedContactsScreen extends ConsumerWidget {
  const ExcludedContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // استهلاك الـ ViewModel
    final state = ref.watch(groupPrivacyViewModelProvider);
    final viewModel = ref.read(groupPrivacyViewModelProvider.notifier);

    final sortedContacts = viewModel.sortedContacts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Excluded Contacts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (state.filteredContacts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: viewModel.toggleSelectAll,
            ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: Loeading())
          : state.error != null
          ? Center(child: Text(state.error!))
          : ListView.separated(
        itemCount: sortedContacts.length,
        separatorBuilder: (_, index) {
          final current = sortedContacts[index];
          final next = index + 1 < sortedContacts.length
              ? sortedContacts[index + 1]
              : null;
          if (next != null &&
              state.excludedUids.contains(current.uid) &&
              !state.excludedUids.contains(next.uid)) {
            return const Divider();
          }
          return const SizedBox.shrink();
        },
        itemBuilder: (context, index) {
          final contact = sortedContacts[index];
          return _buildContactTile(context, viewModel, contact, state, ref);
        },
      ),
      floatingActionButton: state.hasChanges
          ? FloatingActionButton(
        onPressed: () async {
          final success = await viewModel.saveExcludedContacts();
          if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Unexpected error occurred.'),
              ),
            );
          } else if (context.mounted) {
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.check),
      )
          : null,
    );
  }

  Widget _buildContactTile(
      BuildContext context,
      GroupPrivacyViewModel viewModel,
      UserEntity contact,
      GroupPrivacyState state,
      WidgetRef ref,
      ) {
    final isSelected = state.excludedUids.contains(contact.uid);

    const double avatarRadius = 20.0;
    const double iconSize = 16.0;

    final currentUser = ref.watch(userStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid ?? '';

    // استهلاك المزود profilePhotoVisibilityProvider
    final canViewPhotoAsync = ref.watch(profilePhotoVisibilityProvider({
      'currentUserId': currentUserId,
      'otherUserId': contact.uid,
    }));

    return canViewPhotoAsync.when(
      loading: () => ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          radius: avatarRadius,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
        title: Text(contact.name),
      ),
      error: (_, __) => ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          radius: avatarRadius,
          child: Icon(
            Icons.person,
            size: iconSize * 2,
            color: Colors.white,
          ),
        ),
        title: Text(contact.name),
      ),
      data: (canViewPhoto) {
        return ListTile(
          leading: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: canViewPhoto && contact.profile.isNotEmpty
                ? CachedNetworkImageProvider(contact.profile)
                : null,
            child: (!canViewPhoto || contact.profile.isEmpty)
                ? Icon(
              Icons.person,
              size: iconSize * 2,
              color: Colors.white,
            )
                : null,
          ),
          title: Text(contact.name),
          trailing: Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected ? Colors.green : null,
          ),
          onTap: () => viewModel.toggleExcludedUid(contact.uid),
        );
      },
    );
  }
}
