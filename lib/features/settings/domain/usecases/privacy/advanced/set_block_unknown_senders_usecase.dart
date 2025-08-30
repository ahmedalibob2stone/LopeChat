
import 'package:firebase_auth/firebase_auth.dart';

import '../../../repository/privacy/advanced/advanced_privacy_repository.dart';

class SetBlockUnknownSendersUseCase {
  final AdvancedPrivacyRepository repository;
  final FirebaseAuth firebaseAuth;

  SetBlockUnknownSendersUseCase({
    required this.repository,
    required this.firebaseAuth,
  });

  Future<void> call(bool value) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    await repository.setBlockUnknownSenders(user.uid, value);
  }
}
