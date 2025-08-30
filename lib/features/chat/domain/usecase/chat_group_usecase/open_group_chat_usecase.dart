import '../../repository/chat_group_repository.dart';

class OpenGroupChatUseCase {
  final ChatGroupRepository repository;

  OpenGroupChatUseCase(this.repository);

  Future<void> execute(String groupId) async {
    await repository.openGroupChat(groupId);
  }
}
