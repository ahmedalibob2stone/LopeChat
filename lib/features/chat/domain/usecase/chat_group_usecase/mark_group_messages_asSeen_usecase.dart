

import '../../repository/chat_group_repository.dart';

class MarkGroupMessagesAsSeenUseCase {
  final ChatGroupRepository repository;

  MarkGroupMessagesAsSeenUseCase(this.repository);

  Future<void> execute({
    required String groupId,
    required String uid,
  }) async {
    await repository.markGroupMessagesAsSeen(groupId: groupId, uid: uid);
  }
}
