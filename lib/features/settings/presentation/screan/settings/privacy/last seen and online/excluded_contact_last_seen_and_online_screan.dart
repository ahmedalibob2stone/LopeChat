import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../../../../common/widgets/Loeading.dart';
import '../../../../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../../../../provider/privacy/last seen and online/vm/provider.dart';

class ExcludedContactsLastSeenAndOnlineScreen extends ConsumerWidget {
  const ExcludedContactsLastSeenAndOnlineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة حالة ViewModel للـ Last Seen & Online
    final state = ref.watch(lastSeenAndOnlineViewModelProvider);
    final viewModel = ref.read(lastSeenAndOnlineViewModelProvider.notifier);

    // جهات الاتصال مرتبة (حسب ViewModel)
    final sortedContacts = viewModel.sortedContacts;

    const double leadingRadius = 20.0;
    const double fontSize = 16.0;

    // مستخدم التطبيق الحالي (لتحديد ال uid)
    final currentUser = ref.watch(currentUserStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: const Text('Excluded Contacts'),
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
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final contact = sortedContacts[index];
          final isExcluded = state.privacySettings?.lastSeenExceptUids.contains(contact.uid) ?? false;

          final canViewPhotoAsync = ref.watch(profilePhotoVisibilityProvider({
            'currentUserId': currentUserId ?? '',
            'otherUserId': contact.uid,
          }));

          return canViewPhotoAsync.when(
            loading: () => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                radius: leadingRadius,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              title: Text(contact.name),
            ),
            error: (err, stack) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                radius: leadingRadius,
                child: Icon(
                  Icons.person,
                  size: fontSize * 2,
                  color: Colors.white,
                ),
              ),
              title: Text(contact.name),
            ),
            data: (canViewPhoto) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  radius: leadingRadius,
                  backgroundImage: canViewPhoto && contact.profile.isNotEmpty
                      ? CachedNetworkImageProvider(contact.profile)
                      : null,
                  child: !canViewPhoto || contact.profile.isEmpty
                      ? Icon(
                    Icons.person,
                    size: fontSize * 2,
                    color: Colors.white,
                  )
                      : null,
                ),
                title: Text(contact.name),
                trailing: Icon(
                  isExcluded ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isExcluded ? Colors.green : null,
                ),
                onTap: () => viewModel.toggleExcludedUid(contact.uid),
              );
            },
          );
        },
      ),
      floatingActionButton: state.hasChanges
          ? FloatingActionButton(
        onPressed: () async {
          final success = await viewModel.saveExcludedUids();
          if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Unexpected error occurred.')),
            );
          } else {
            if (context.mounted) Navigator.pop(context);
          }
        },
        child: const Icon(Icons.check),
      )
          : null,
    );
  }
}
