import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../../user/data/user_model/user_model.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/firebase_contact_datasorce.dart';

class ContactRepositoryImpl implements IContactRepository {
  final FirebaseContactDataSource dataSource;

  ContactRepositoryImpl(this.dataSource);

  @override
  Future<Map<String, List<UserEntity>>> getAllContacts({
    required String currentUserPhone,
    required String currentUserCountry, // أصبح ضروري
  }) async {
    // جلب البيانات من المصدر
    final rawData = await dataSource.getAllContacts(
      currentUserPhone: currentUserPhone,
      currentUserCountry: currentUserCountry,
    );

    // تحويل UserModel إلى UserEntity
    final appContacts = rawData['appContacts']!
        .map((u) => u.toEntity())
        .toList();
    final nonAppContacts = rawData['nonAppContacts']!
        .map((u) => u.toEntity())
        .toList();

    return {
      'appContacts': appContacts,
      'nonAppContacts': nonAppContacts,
    };
  }

  @override
  Future<List<UserEntity>> getAppContacts({
    required String currentUserCountry, // أصبح ضروري
  }) async {
    final result = await dataSource.getAppContacts(
      currentUserCountry: currentUserCountry,
    );

    final appContacts = result.map((user) => user.toEntity()).toList();

    return appContacts;
  }
}
