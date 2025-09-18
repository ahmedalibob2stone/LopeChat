import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/get_app_contacts.dart';
import '../datasorce/get_all_contacts_datasorce_provider.dart';
final getAppContactsUseCaseProvider = Provider<GetAppContactsUseCase>((ref) {
  final repository = ref.watch(contactRepositoryProvider);
  final String uid = FirebaseAuth.instance.currentUser!.uid;

    final String currentUserCountry = '';

  return GetAppContactsUseCase(
    repository: repository,
    uid: uid,
    currentUserCountry: currentUserCountry,
  );
});
