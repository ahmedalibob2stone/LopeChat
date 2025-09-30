import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/contact_entities.dart';
import '../../../domain/usecase/chat_contact/archive_chat_usecase.dart';
import '../../../domain/usecase/chat_contact/get_archived_chats_usecase.dart';
import '../../../domain/usecase/chat_contact/get_unarchived_chats_use_case.dart';
import '../../../domain/usecase/chat_contact/unarchive_chat_usecase.dart';




class ArchiveChatContactState {
  final bool isLoading;
  final List<ChatContactEntity> contacts;
  final List<ChatContactEntity> archivedContacts;
  final String? error;

  ArchiveChatContactState({
    this.isLoading = false,
    this.contacts = const [],
    this.archivedContacts = const [],
    this.error,
  });

  ArchiveChatContactState copyWith({
    bool? isLoading,
    List<ChatContactEntity>? contacts,
    List<ChatContactEntity>? archivedContacts,
    String? error,
  }) {
    return ArchiveChatContactState(
      isLoading: isLoading ?? this.isLoading,
      contacts: contacts ?? this.contacts,
      archivedContacts: archivedContacts ?? this.archivedContacts,
      error: error,
    );
  }
}

class ArchiveChatContactViewModel extends StateNotifier<ArchiveChatContactState> {
  final GetArchivedChatsUseCase getArchivedChatsUseCase;
  final GetUnarchivedChatsUseCase getUnarchivedChatsUseCase;
  final ArchiveChatUseCase archiveChatUseCase;
   final UnarchiveChatUseCase unarchiveChatUseCase;

  StreamSubscription<List<ChatContactEntity>>? _contactSubscription;
  StreamSubscription<List<ChatContactEntity>>? _archivedSubscription;

  ArchiveChatContactViewModel({
    required this.getArchivedChatsUseCase,
    required this.getUnarchivedChatsUseCase,
    required this.archiveChatUseCase,
    required this.unarchiveChatUseCase,
  }) : super(ArchiveChatContactState());

  Future<void> loadUnarchivedChats() async{
    state = state.copyWith(isLoading: true);
    _contactSubscription?.cancel();
    _contactSubscription = getUnarchivedChatsUseCase().listen(
          (contacts) {
        state = state.copyWith(isLoading: false, contacts: contacts);
      },
      onError: (error) {
        state = state.copyWith(isLoading: false, error: error.toString());
      },
    );
  }

  Future<void> loadArchivedChats()async {
    _archivedSubscription?.cancel();
    _archivedSubscription = getArchivedChatsUseCase().listen(
          (contacts) {
        state = state.copyWith(archivedContacts: contacts);
      },
      onError: (error) {
        state = state.copyWith(error: error.toString());
      },
    );
  }

  Future<void> archiveChat(String chatId) async {
    await archiveChatUseCase(chatId);
  }
  Future<void> UnachiveChat(String chatId) async {
    await unarchiveChatUseCase(chatId);
  }


  @override
  void dispose() {
    _contactSubscription?.cancel();
    _archivedSubscription?.cancel();
    super.dispose();
  }
}
