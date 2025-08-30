



import '../../repository/chat_group_repository.dart';

class DeleteGroupChatMessagesUseCase {
  final ChatGroupRepository repository;

  DeleteGroupChatMessagesUseCase(this.repository);

  Future<void> execute({required String groupId}) async {
    return await repository.deleteGroupChatMessages(groupId: groupId);
  }
}
