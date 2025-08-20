import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/firebase_contact_datasorce.dart';
import '../../../data/repositories/contact_repository_impl.dart';
import '../../../domain/usecase/get_app_contacts.dart';
final contactDataSourceProvider = Provider<FirebaseContactDataSource>((ref) {
  return FirebaseContactDataSource(firestore: FirebaseFirestore.instance);
});
final contactRepositoryProvider = Provider<ContactRepositoryImpl>((ref) {
  final dataSource = ref.watch(contactDataSourceProvider);
  return ContactRepositoryImpl(dataSource);
});
final getAppContactsUseCaseProvider = Provider<GetAppContactsUseCase>((ref) {
  final repository = ref.watch(contactRepositoryProvider);
  final String uid=FirebaseAuth.instance.currentUser!.uid;
  return GetAppContactsUseCase(repository,uid);
});
final someProvider = Provider.family<GetAppContactsUseCase, String>((ref, userId) {
  final repo = ref.read(contactRepositoryProvider);
  return GetAppContactsUseCase(repo, userId);
});
