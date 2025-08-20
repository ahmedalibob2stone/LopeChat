import 'package:firebase_auth/firebase_auth.dart';

import '../../../repository/privacy/auto disappear message/auto_disappear_messages_privacy_repository.dart';

class GetDefaultDisappearTimerUseCase {
  final AutoDisappearMassagesPrivacyRepository repository;
  final FirebaseAuth auth;

  GetDefaultDisappearTimerUseCase({
    required this.repository,
    required this.auth,
  });

  Future<String?> call() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not authenticated');
    }
    return await repository.getDefaultDisappearTimer(uid);
  }
}
