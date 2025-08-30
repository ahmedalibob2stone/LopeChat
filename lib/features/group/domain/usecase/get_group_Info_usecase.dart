import '../entities/group_entity.dart';
import '../repository/group_repository.dart';

class GetGroupInfoUseCase {
  final IGroupRepository repository;

  GetGroupInfoUseCase(this.repository);

  Future<GroupEntity> execute(String groupId) {
    return repository.getGroupById(groupId);
  }
}
