import '../repository/group_repository.dart';

class DeleteGroupUseCase {
  final IGroupRepository repository;

  DeleteGroupUseCase(this.repository);

  Future<void> execute(String groupId) {
    return repository.deleteGroup(groupId);
  }
}
