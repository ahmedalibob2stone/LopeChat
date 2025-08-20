import '../../repository/chat_group_repository.dart';

class UnarchiveGroupChatUseCase {
  final ChatGroupRepository repository;

  UnarchiveGroupChatUseCase(this.repository);

  Future<void> call({required String groupId, required String userId}) {
    return repository.unarchiveGroupChat(groupId: groupId, userId: userId);
  }
}
