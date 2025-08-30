
import '../../../../group/domain/entities/group_entity.dart';
import '../../repository/chat_group_repository.dart';


class GetArchivedGroupsUseCase {
  final ChatGroupRepository repository;

  GetArchivedGroupsUseCase(this.repository);

  Stream<List<GroupEntity>> call(String userId) {
    return repository.getArchivedGroups(userId);
  }
}
