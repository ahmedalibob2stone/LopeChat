import '../../../user/domain/entities/user_entity.dart';

abstract class IContactRepository {
  Future<Map<String, List<UserEntity>>> getAllContacts({
    required String currentUserPhone,
    required String currentUserCountry, // أصبح ضروري
  });
  Future<List<UserEntity>> getAppContacts({
    required String currentUserCountry, // أصبح ضروري
  });
}
