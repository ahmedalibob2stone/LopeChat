import '../../../user/domain/entities/user_entity.dart';
import '../repositories/contact_repository.dart';

class GetAllContactsUseCase {
  final IContactRepository repository;

  GetAllContactsUseCase(this.repository);

  Future<Map<String, List<UserEntity>>> call({
    required String currentUserPhone,
    required String currentUserCountry,
  }) async {
    return await repository.getAllContacts(
      currentUserPhone: currentUserPhone,
      currentUserCountry: currentUserCountry,
    );
  }
}
