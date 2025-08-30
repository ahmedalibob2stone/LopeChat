


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/firebase_contact_datasorce.dart';
import '../../../data/repositories/contact_repository_impl.dart';
import '../../../domain/usecase/get_all_contacts.dart';

final contactDataSourceProvider = Provider<FirebaseContactDataSource>((ref) {
  return FirebaseContactDataSource(firestore: FirebaseFirestore.instance);
});
final contactRepositoryProvider = Provider<ContactRepositoryImpl>((ref) {
  final dataSource = ref.watch(contactDataSourceProvider);
  return ContactRepositoryImpl(dataSource);
});
final getAllContactUseCaseProvider = Provider<GetAllContactUseCase>((ref) {
  final repository = ref.watch(contactRepositoryProvider);
  return GetAllContactUseCase(repository);
});


