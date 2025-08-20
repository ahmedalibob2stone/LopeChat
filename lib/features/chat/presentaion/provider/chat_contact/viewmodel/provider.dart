

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecase/chat_contact/delete_chat_usecase.dart';
import '../../../viewmodel/chat_contact/delet_chat_contact_view_model.dart';
import '../../../viewmodel/chat_contact/archive_chat_contact_viewmodel.dart';
import '../../../viewmodel/chat_contact/search_contact_view_model.dart';
import '../data/provider.dart';
import '../usecase/provider.dart';
final chatContactViewModelProvider =
StateNotifierProvider<ArchiveChatContactViewModel, ChatContactState>((ref) {
  final archiveUseCase = ref.watch(archiveChatUseCaseProvider);
  final getArchivedUseCase = ref.watch(getArchivedChatsUseCaseProvider);
  final getUnarchivedUseCase = ref.watch(getUnarchivedChatsUseCaseProvider);
  final unarchiveChatUseCase=ref.watch(unarchiveChatUseCaseProvider);

  return ArchiveChatContactViewModel(
    archiveChatUseCase: archiveUseCase,
    getArchivedChatsUseCase: getArchivedUseCase,
    getUnarchivedChatsUseCase: getUnarchivedUseCase, unarchiveChatUseCase:unarchiveChatUseCase,
  );
});
// lib/feature/chat_contact/presentation/provider/usecase/delete_chat_usecase_provider.dart

final deleteChatViewModelProvider = StateNotifierProvider<DeleteChatViewModel, DeleteChatState>((ref) {
  final deleteChatUseCase = ref.watch(deleteChatUseCaseProvider);
  return DeleteChatViewModel(deleteChatUseCase);
});

final searchChatViewModelProvider = StateNotifierProvider<SearchChatContactViewModel, SearchContactState>((ref) {
  final searchUseCase = ref.watch(SearchContactUseCaseProvider);
  return SearchChatContactViewModel(
    searchContactUseCase: searchUseCase,

  );
});
