
import '../../repository/chat_group_repository.dart';

class ArchiveGroupChatUseCase {
  final ChatGroupRepository repository;

  ArchiveGroupChatUseCase(this.repository);

  Future<void> call({required String groupId, required String userId}) {
    return repository.archiveGroupChat(groupId: groupId, userId: userId);
  }
}
