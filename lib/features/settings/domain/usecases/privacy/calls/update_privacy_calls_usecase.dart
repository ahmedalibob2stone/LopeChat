import 'package:firebase_auth/firebase_auth.dart';

import '../../../repository/privacy/calls/privacy_calls_repository.dart';

class UpdatePrivacyCallsUseCase {
  final PrivacyCallsRepository repository;
  final FirebaseAuth auth;

  UpdatePrivacyCallsUseCase({
    required this.repository,
    required this.auth,
  });

  Future<void> call(bool silence) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not authenticated");
    final uid = user.uid;
    await repository.updatePrivacyCalls(silence, uid);
  }
}
