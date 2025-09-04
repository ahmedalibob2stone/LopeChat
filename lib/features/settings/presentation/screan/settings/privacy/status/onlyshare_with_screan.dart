import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../../../../provider/privacy/statu/vm/status_privascy_viewmodel.dart';
import '../../../../viewmodel/privacy/statu/status_privacy_viewmodel.dart';


class ShareWithOnlyScreen extends ConsumerStatefulWidget {
  const ShareWithOnlyScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ShareWithOnlyScreen> createState() => _ShareWithOnlyScreenState();
}

class _ShareWithOnlyScreenState extends ConsumerState<ShareWithOnlyScreen> {
  late List<String> tempIncludedIds;
  bool _isSearching = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    final state = ref.read(statusPrivacyProvider);
    tempIncludedIds = List.from(state.includedContactsIds);

    // Listen for messages and show Snackbar
    ref.listen<StatusPrivacyState>(statusPrivacyProvider, (previous, next) {
      if (next.message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
        ref.read(statusPrivacyProvider.notifier).clearMessage();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statusPrivacyProvider);
    final vm = ref.read(statusPrivacyProvider.notifier);

    final currentUser = ref.watch(currentUserStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid ?? '';

    final contacts = state.filteredContacts;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
              vm.updateSearchQuery('');
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search contacts...',
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          onChanged: (val) => vm.updateSearchQuery(val),
        )
            : Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Share status with ...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Contacts — ${state.includedCount}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: () {
              setState(() {
                tempIncludedIds = contacts.map((e) => e.uid).toList();
              });
            },
          ),
        ],
      ),
      body: contacts.isEmpty
          ? Center(
        child: _isSearching
            ? const Text('No results matching your search')
            : const Text('No contacts found'),
      )
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          final isSelected = tempIncludedIds.contains(contact.uid);

          final profilePhotoVisibilityAsync = ref.watch(profilePhotoVisibilityProvider({
            'currentUserId': currentUserId,
            'otherUserId': contact.uid,
          }));

          return profilePhotoVisibilityAsync.when(
            data: (canViewPhoto) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: canViewPhoto && contact.profile.isNotEmpty
                      ? NetworkImage(contact.profile)
                      : null,
                  child: (!canViewPhoto || contact.profile.isEmpty)
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(contact.name),
                trailing: IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: isSelected ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isSelected) {
                        tempIncludedIds.remove(contact.uid);
                      } else {
                        tempIncludedIds.add(contact.uid);
                      }
                    });
                  },
                ),
              );
            },
            loading: () => const ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Checking...'),
            ),
            error: (error, stack) => const ListTile(
              leading: Icon(Icons.error, color: Colors.red),
              title: Text('Error checking status'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          // Sync changes with ViewModel
          for (var id in state.includedContactsIds) {
            if (!tempIncludedIds.contains(id)) {
              vm.toggleIncludedContact(id);
            }
          }

          for (var id in tempIncludedIds) {
            if (!state.includedContactsIds.contains(id)) {
              vm.toggleIncludedContact(id);
            }
          }

          await vm.applyChanges();

          Navigator.pop(context);
        },
      ),
    );
  }
}
