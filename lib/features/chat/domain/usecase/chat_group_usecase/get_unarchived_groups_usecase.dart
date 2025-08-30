

import '../../../../group/domain/entities/group_entity.dart';
import '../../repository/chat_group_repository.dart';


class GetUnarchivedGroupsUseCase {
  final ChatGroupRepository repository;

  GetUnarchivedGroupsUseCase(this.repository);

  Stream<List<GroupEntity>> call(String userId) {
    return repository.getUnarchivedGroups(userId);
  }
}
