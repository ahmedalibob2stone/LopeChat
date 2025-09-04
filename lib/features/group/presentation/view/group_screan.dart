import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../common/contact/provider/contacts_provider.dart';
import '../../../../common/widgets/Error_Screan.dart';
import '../../../../common/widgets/Loeading.dart';
import '../../../contact/presentation/provider/vm/get_app_contact_viewmodel_provider.dart';
import '../../../settings/presentation/provider/privacy/profile/vm/provider.dart';
import '../../../user/presentation/provider/stream_provider/get_user_data_stream_provider.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectContactsGroup> createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
      ref.read(selectedGroupContacts.notifier).update(
            (state) => state.where((c) => c.id != contact.id).toList(),
      );
    } else {
      selectedContactsIndex.add(index);
      ref.read(selectedGroupContacts.notifier).update(
            (state) => [...state, contact],
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(getAppContactsViewModelProvider.notifier).loadAppContacts();
      final contacts = ref.read(getAppContactsViewModelProvider).contacts;
      await ref.read(profilePrivacyProvider.notifier).loadData(contacts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserStreamProvider);
    final contactsAsync = ref.watch(getContactsProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth * 0.045;
    final double iconSize = screenWidth * 0.07;
    final double avatarRadius = screenWidth * 0.07;
    final double padding = screenWidth * 0.02;

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const Center(child: Text("Failed to load current user"));
        }

        return contactsAsync.when(
          data: (contactList) => Expanded(
            child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                final isSelected = selectedContactsIndex.contains(index);

                final currentUserId = currentUser.uid;

                final profilePhotoVisibility = ref.watch(profilePhotoVisibilityProvider({
                  'currentUserId': currentUserId,
                  'otherUserId': contact.id,
                }));

                return profilePhotoVisibility.when(
                  data: (canSeePhoto) {
                    return InkWell(
                      onTap: () => selectContact(index, contact),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: padding),
                        child: ListTile(
                          title: Text(
                            contact.displayName,
                            style: TextStyle(fontSize: titleFontSize),
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                            isSelected ? Colors.grey[400] : Colors.grey.withOpacity(0.4),
                            radius: avatarRadius,
                            child: canSeePhoto && contact.photo != null && contact.photo!.isNotEmpty
                                ? ClipOval(
                              child: Image.memory(
                                contact.photo!,
                                fit: BoxFit.cover,
                                width: avatarRadius * 2,
                                height: avatarRadius * 2,
                              ),
                            )
                                : Icon(
                              Icons.person,
                              color: Colors.white,
                              size: iconSize,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : const Icon(Icons.radio_button_unchecked),
                        ),
                      ),
                    );
                  },
                  loading: () => Padding(
                    padding: EdgeInsets.only(bottom: padding),
                    child: const ListTile(
                      title: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  error: (e, _) => Padding(
                    padding: EdgeInsets.only(bottom: padding),
                    child: ListTile(title: Text("Error: $e")),
                  ),
                );
              },
            ),
          ),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => const Loeading(),
        );
      },
      error: (err, stack) => ErrorScreen(error: err.toString()),
      loading: () => const Loeading(),
    );
  }
}
