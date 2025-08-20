
import '../repository/group_repository.dart';

class LeaveGroupUseCase {
  final IGroupRepository repository;

  LeaveGroupUseCase(this.repository);

  Future<void> execute(String groupId) {
    return repository.leaveGroup(groupId);
  }
}
