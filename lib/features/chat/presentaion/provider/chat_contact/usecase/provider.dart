
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecase/chat_contact/archive_chat_usecase.dart';
import '../../../../domain/usecase/chat_contact/delete_chat_usecase.dart';
import '../../../../domain/usecase/chat_contact/get_archived_chats_usecase.dart';
import '../../../../domain/usecase/chat_contact/get_chat_contact_usecase.dart';
import '../../../../domain/usecase/chat_contact/get_unarchived_chats_use_case.dart';
import '../../../../domain/usecase/chat_contact/search_contact_usecase.dart';
import '../../../../domain/usecase/chat_contact/unarchive_chat_usecase.dart';
import '../data/provider.dart';

final SearchContactUseCaseProvider=Provider<SearchContactUseCase>((ref)
{final repository=ref.watch(ChatContactRepositoryProvider);
  return SearchContactUseCase(repository: repository);

}
);
final archiveChatUseCaseProvider = Provider<ArchiveChatUseCase>((ref) {
  final repository = ref.watch(ChatContactRepositoryProvider);
  return ArchiveChatUseCase(repository: repository);
});

final getUnarchivedChatsUseCaseProvider = Provider<GetUnarchivedChatsUseCase>((ref) {
  final repository = ref.watch(ChatContactRepositoryProvider);
  return GetUnarchivedChatsUseCase(repositiry:repository);
});

final getArchivedChatsUseCaseProvider = Provider<GetArchivedChatsUseCase>((ref) {
  final repository = ref.watch(ChatContactRepositoryProvider);
  return GetArchivedChatsUseCase(repository: repository);
});

final unarchiveChatUseCaseProvider = Provider<UnarchiveChatUseCase>((ref) {
  final repository = ref.watch(ChatContactRepositoryProvider);
  return UnarchiveChatUseCase(repository: repository);
});

final deleteChatUseCaseProvider = Provider<DeleteChatUseCase>((ref) {
  final repository = ref.watch(ChatContactRepositoryProvider);
  return DeleteChatUseCase(repository);
});
final getChatContactUsecaseProvider = Provider<GetChatContactsUseCase>((ref) {
  final repository = ref.read(ChatContactRepositoryProvider);
  return GetChatContactsUseCase( repository: repository);
});