import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/select_contact_controller.dart';
import '../repository/get_all_contacts_repository_provider.dart';

final contactsControllerProvider =
StateNotifierProvider<GetAllContactsViewModel, ContactsStateManager>(
      (ref) {
    final useCase = ref.watch(getAllContactsUseCaseProvider); // UseCase مع named parameters
    const currentUserPhone = '+967xxxxxxxx';
    const currentUserCountry = 'YE';

    return GetAllContactsViewModel(
      getAllContactsUseCase: useCase,
      currentUserPhone: currentUserPhone,
      currentUserCountry: currentUserCountry,
    );
  },
);
