
import '../repository/group_repository.dart';

class DeleteMemberFromGroupUseCase {
  final IGroupRepository repository;

  DeleteMemberFromGroupUseCase(this.repository);

  Future<void> execute({
    required String groupId,
    required String memberId,
  }) {
    return repository.deleteMemberFromGroup(groupId: groupId, memberId: memberId);
  }
}
