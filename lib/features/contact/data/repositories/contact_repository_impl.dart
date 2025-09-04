import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../user/domain/entities/user_entity.dart';
import '../../../user/data/user_model/user_model.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/firebase_contact_datasorce.dart';

class ContactRepositoryImpl implements IContactRepository {
  final FirebaseContactDataSource dataSource;

  ContactRepositoryImpl(this.dataSource);

  @override
  Future<List<List<UserEntity>>> getAllContacts() async {
    final result = await dataSource.getAllContacts();
    final appContacts = result[0].map((user) => user.toEntity()).toList();
    final nonAppContacts = result[1].map((user) => user.toEntity()).toList();
    return [appContacts, nonAppContacts];
  }
  @override
  Future<List<UserEntity>> getAppContacts() async {
    final result = await dataSource.getAppContacts();

      final appContacts = result.map((user) => user.toEntity()).toList();

    return appContacts;
  }



}
