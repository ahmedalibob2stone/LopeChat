import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../../../user/presentation/provider/stream_provider/get_user_data_stream_provider.dart';
import '../../../../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../../../../provider/privacy/statu/vm/status_privascy_viewmodel.dart';
import '../../../../viewmodel/privacy/statu/status_privacy_viewmodel.dart';

class ContactsExceptScreen extends ConsumerStatefulWidget {
  const ContactsExceptScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ContactsExceptScreen> createState() => _ContactsExceptScreenState();
}

class _ContactsExceptScreenState extends ConsumerState<ContactsExceptScreen> {
  late List<String> tempExcludedIds;
  bool _isSearching = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    final state = ref.read(statusPrivacyProvider);
    tempExcludedIds = List.from(state.excludedContactsIds);

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
    final currentUserId = currentUser?.uid;

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
          onChanged: (val) {
            vm.updateSearchQuery(val);
          },
        )
            : Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Hide status from...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Contacts — ${state.excludedContactsIds.length}',
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
                tempExcludedIds = contacts.map((e) => e.uid).toList();
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
          final isSelected = tempExcludedIds.contains(contact.uid);

          final profilePhotoVisibilityAsync = ref.watch(profilePhotoVisibilityProvider({
            'currentUserId': currentUserId ?? '',
            'otherUserId': contact.uid,
          }));

          return profilePhotoVisibilityAsync.when(
            data: (canViewPhoto) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: canViewPhoto && contact.profile.isNotEmpty
                      ? NetworkImage(contact.profile!)
                      : null,
                  child: (!canViewPhoto || contact.profile.isEmpty)
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(contact.name),
                trailing: IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: isSelected ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isSelected) {
                        tempExcludedIds.remove(contact.uid);
                      } else {
                        tempExcludedIds.add(contact.uid);
                      }
                    });
                  },
                ),
              );
            },
            loading: () => const ListTile(
              leading: CircleAvatar(child: CircularProgressIndicator(strokeWidth: 2)),
              title: Text('Loading...'),
            ),
            error: (error, stack) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.error)),
              title: Text('Error loading data: $error'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          for (var id in state.excludedContactsIds) {
            if (!tempExcludedIds.contains(id)) {
              vm.toggleExcludedContact(id);
            }
          }

          for (var id in tempExcludedIds) {
            if (!state.excludedContactsIds.contains(id)) {
              vm.toggleExcludedContact(id);
            }
          }

          await vm.applyChanges();
          Navigator.pop(context);
        },
      ),
    );
  }
}
