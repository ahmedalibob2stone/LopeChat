
import '../repository/group_repository.dart';

class AddAdminUseCase {
  final IGroupRepository repository;

  AddAdminUseCase(this.repository);

  Future<void> execute({
    required String groupId,
    required String adminUid,
  }) async {
    await repository.addAdmin(groupId, adminUid);
  }
}


