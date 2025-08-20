import '../../../../group/domain/entities/group_entity.dart';
import '../../repository/chat_group_repository.dart';

class GetChatGroupsUseCase {
  final ChatGroupRepository repository;

  GetChatGroupsUseCase(this.repository);

  Stream<List<GroupEntity>> call() {
    return repository.getChatGroups();
  }
}
