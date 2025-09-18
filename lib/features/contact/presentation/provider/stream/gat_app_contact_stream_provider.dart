import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecase/get_app_contacts.dart';
import '../datasorce/get_all_contacts_datasorce_provider.dart';
final someProvider = Provider.family<GetAppContactsUseCase, String>((ref, currentUserCountry) {
  final repo = ref.read(contactRepositoryProvider);
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  return GetAppContactsUseCase(
    repository: repo,
    uid: uid,
    currentUserCountry: currentUserCountry,
  );
});