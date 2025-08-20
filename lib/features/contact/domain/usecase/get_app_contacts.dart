
import '../../../user/domain/entities/user_entity.dart';
import '../repositories/contact_repository.dart';

class GetAppContactsUseCase {
  final IContactRepository repository;
  final String uid;
  GetAppContactsUseCase(this.repository, this.uid);

  Future<List<UserEntity>> call() async {
    return await repository.getAppContacts();
  }
}
