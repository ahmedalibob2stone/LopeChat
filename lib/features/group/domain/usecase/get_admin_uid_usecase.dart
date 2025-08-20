

import '../repository/group_repository.dart';

class GetAdminUidUseCase {
  final IGroupRepository repository;

  GetAdminUidUseCase(this.repository);

  Future<String> execute(String groupId) async {
    return await repository.getAdminUid(groupId);
  }
}
