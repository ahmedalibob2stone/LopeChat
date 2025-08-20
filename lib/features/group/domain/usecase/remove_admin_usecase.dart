
import '../repository/group_repository.dart';

class RemoveAdminUseCase {
  final IGroupRepository repository;

  RemoveAdminUseCase(this.repository);

  Future<void> execute({
    required String groupId,
    required String adminUid,
  }) async {
    await repository.removeAdmin(groupId, adminUid);
  }
}