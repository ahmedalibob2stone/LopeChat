import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../../../contact/presentation/provider/vm/get_app_contact_viewmodel_provider.dart';
import '../../../../../../contact/presentation/viewmodel/get_app_contacts_viewmodel.dart';
import '../../../../../../profile/presentation/provider/block/vm/viewmodel_provider.dart';
import '../../../../../../user/provider/get_userdata_provider.dart';

class SelectContactToBlockScreen extends ConsumerStatefulWidget {
  const SelectContactToBlockScreen({super.key});

  @override
  ConsumerState<SelectContactToBlockScreen> createState() => _SelectContactToBlockScreenState();
}

class _SelectContactToBlockScreenState extends ConsumerState<SelectContactToBlockScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // تحميل جهات الاتصال عند بدء الشاشة
    Future.microtask(() => ref.read(getAppContactsViewModelProvider.notifier).loadAppContacts());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getAppContactsViewModelProvider);
    final currentUser = ref.watch(userStreamProvider).asData?.value;

    ref.listen<ContactsState>(getAppContactsViewModelProvider, (previous, next) {
      if (next.status == ContactsStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Error occurred')),
        );
        Navigator.pop(context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value.trim().toLowerCase()),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search contacts...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Builder(
            builder: (context) {
              switch (state.status) {
                case ContactsStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case ContactsStatus.loaded:
                  final filteredContacts = state.contacts.where((contact) {
                    final name = contact.name.toLowerCase();
                    final phone = contact.phoneNumber.toLowerCase();
                    return name.contains(searchQuery) || phone.contains(searchQuery);
                  }).toList();

                  if (filteredContacts.isEmpty) {
                    return const Center(child: Text('No matching contacts'));
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final user = filteredContacts[index];

                        if (currentUser == null) {
                          return const ListTile(title: Text("Loading current user..."));
                        }

                        final canSeeProfilePhotoAsync = ref.watch(
                          profilePhotoVisibilityProvider({
                            'currentUserId': currentUser.uid,
                            'otherUserId': user.uid,
                          }),
                        );

                        return canSeeProfilePhotoAsync.when(
                          loading: () => const ListTile(
                            title: Text("Loading..."),
                            trailing: CircularProgressIndicator(),
                          ),
                          error: (_, __) => ListTile(
                            title: Text(user.name),
                            subtitle: const Text("Error loading privacy"),
                          ),
                          data: (canSee) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: canSee
                                    ? NetworkImage(user.profile)
                                    : null,
                                child: canSee ? null : const Icon(Icons.person_off),
                              ),
                              title: Text(user.name),
                              subtitle: Text(user.phoneNumber),
                              trailing: IconButton(
                                icon: const Icon(Icons.block),
                                onPressed: () async {
                                  _showLoadingDialog(context);

                                  final vm = ref.read(blockUserViewModelProvider.notifier);
                                  final currentUserId = currentUser.uid;
                                  final chatId = vm.generateChatId(currentUserId, user.uid);

                                  // تحقق هل محظور بالفعل
                                  final isBlocked = await vm.isblockUserUseCase.isBlocked(
                                    currentUserId: currentUserId,
                                    otherUserId: user.uid,
                                  );

                                  if (isBlocked) {
                                    await vm.unblockUser(currentUserId: currentUserId,);
                                  } else {
                                    await vm.blockUser(
                                      currentUserId: currentUserId,
                                      blockedUserId: user.uid,
                                      chatId: chatId,
                                    );
                                  }

                                  Navigator.pop(context); // Close loading dialog

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(isBlocked ? 'User unblocked' : 'User blocked')),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                case ContactsStatus.error:
                  return Center(child: Text(state.errorMessage ?? 'Failed to load contacts'));
                default:
                  return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text("Please wait..."),
          ],
        ),
      ),
    );
  }
}
