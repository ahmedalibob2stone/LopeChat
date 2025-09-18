import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/contact/presentation/provider/vm/get_all_app_contact_viewmodel_provider.dart.dart';
import '../../features/contact/presentation/viewmodel/select_contact_controller.dart';

class ContactsCountWidget extends ConsumerWidget {
  const ContactsCountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsState = ref.watch(contactsControllerProvider);

    switch (contactsState.status) {
      case ContactsLoadStatus.loading:
        return Text(
          'Counting...',
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
        );
      case ContactsLoadStatus.loaded:
        return Text(
          "${contactsState.appContacts.length} contact${contactsState.appContacts.length == 1 ? '' : 's'} on LopeChat",
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
        );

      case ContactsLoadStatus.error:
        return Text(
          'Error: ${contactsState.errorMessage}',
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
        );
      default:
        return const SizedBox();
    }
  }
}
