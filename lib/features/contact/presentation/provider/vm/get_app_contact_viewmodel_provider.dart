import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/get_app_contacts_viewmodel.dart';
import '../usecases/get_app_contacts_usecases_provider.dart';

final getAppContactsViewModelProvider = StateNotifierProvider<GetAppContactsViewModel, ContactsState>((ref) {
  final getAppContacts = ref.watch(getAppContactsUseCaseProvider);

  return GetAppContactsViewModel(getAppContactsUseCase: getAppContacts);
});
