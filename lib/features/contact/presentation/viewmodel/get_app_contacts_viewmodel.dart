import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../user/domain/entities/user_entity.dart';
import '../../domain/usecase/get_app_contacts.dart';

enum ContactsStatus { initial, loading, loaded, error }

class ContactsState {
  final ContactsStatus status;
  final List<UserEntity> contacts;
  final String? errorMessage;

  ContactsState({
    required this.status,
    required this.contacts,
    this.errorMessage,
  });

  factory ContactsState.initial() => ContactsState(
    status: ContactsStatus.initial,
    contacts: [],
    errorMessage: null,
  );

  ContactsState copyWith({
    ContactsStatus? status,
    List<UserEntity>? contacts,
    String? errorMessage,
  }) {
    return ContactsState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      errorMessage: errorMessage,
    );
  }
}

class GetAppContactsViewModel extends StateNotifier<ContactsState> {
  final GetAppContactsUseCase getAppContactsUseCase;

  GetAppContactsViewModel({required this.getAppContactsUseCase,})
      : super(ContactsState.initial()){
  }

  Future<void> loadAppContacts() async {
    state = state.copyWith(status: ContactsStatus.loading, errorMessage: null);
    try {
      final contacts = await getAppContactsUseCase();
      state = state.copyWith(
        status: ContactsStatus.loaded,
        contacts: contacts,
      );
    } catch (e) {
      state = state.copyWith(
        status: ContactsStatus.error,
        errorMessage: 'No internet connection. Please try again.',
      );
    }
  }


}
