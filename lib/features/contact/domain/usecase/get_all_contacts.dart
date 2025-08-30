import '../../../user/domain/entities/user_entity.dart';
import '../repositories/contact_repository.dart';

class GetAllContactUseCase {
  final IContactRepository repository;

  GetAllContactUseCase(this.repository);

  Future<List<List<UserEntity>>> call() {
    return repository.getAllContacts();
  }
}
