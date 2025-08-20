import '../../../user/domain/entities/user_entity.dart';

abstract class IContactRepository {
  Future<List<List<UserEntity>>> getAllContacts();
  Future<List<UserEntity>> getAppContacts();
}
