
import '../../../../group/domain/entities/group_entity.dart';
import '../../repository/chat_group_repository.dart';

class SearchGroupUseCase {
  final ChatGroupRepository repository;

  SearchGroupUseCase(this.repository);

  Stream<List<GroupEntity>> execute({required String searchName}) {
    return repository.searchGroup(searchName: searchName);
  }
}
