import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/contact_entities.dart';
import '../../../domain/usecase/chat_contact/archive_chat_usecase.dart';
import '../../../domain/usecase/chat_contact/get_archived_chats_usecase.dart';
import '../../../domain/usecase/chat_contact/get_unarchived_chats_use_case.dart';
import '../../../domain/usecase/chat_contact/search_contact_usecase.dart';
import '../../../domain/usecase/chat_contact/unarchive_chat_usecase.dart';




class SearchContactState {
  final bool isLoading;
  final List<ChatContactEntity> contacts;
  final String? error;

  SearchContactState({
    this.isLoading = false,
    this.contacts = const [],
    this.error,
  });

  SearchContactState copyWith({
    bool? isLoading,
    List<ChatContactEntity>? contacts,
    List<ChatContactEntity>? archivedContacts,
    String? error,
  }) {
    return SearchContactState(
      isLoading: isLoading ?? this.isLoading,
      contacts: contacts ?? this.contacts,
      error: error,
    );
  }
}

class SearchChatContactViewModel extends StateNotifier<SearchContactState> {
  final SearchContactUseCase searchContactUseCase;


  StreamSubscription<List<ChatContactEntity>>? _contactSubscription;
  StreamSubscription<List<ChatContactEntity>>? _archivedSubscription;

  SearchChatContactViewModel({
    required this.searchContactUseCase,

  }) : super(SearchContactState());

  void searchContacts(String query) {
    state = state.copyWith(isLoading: true, contacts: [], error: null);
    _contactSubscription?.cancel();
    _contactSubscription = searchContactUseCase.execute(query).listen(
          (contacts) {
        state = state.copyWith(isLoading: false, contacts: contacts);
      },
      onError: (error) {
        state = state.copyWith(isLoading: false, error: error.toString());
      },
    );
  }

  @override
  void dispose() {
    _contactSubscription?.cancel();
    _archivedSubscription?.cancel();
    super.dispose();
  }
}
