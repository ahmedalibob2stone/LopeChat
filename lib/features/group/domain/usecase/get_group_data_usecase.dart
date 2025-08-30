

import '../entities/group_entity.dart';
import '../repository/group_repository.dart';

class GetGroupDataUseCase {
  final IGroupRepository repository;

  GetGroupDataUseCase(this.repository);

  Stream<GroupEntity> execute(String groupId) {
    return repository.getGroupData(groupId);
  }
}
