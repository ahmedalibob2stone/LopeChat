import 'package:firebase_auth/firebase_auth.dart';

import '../../../repository/privacy/auto disappear message/auto_disappear_messages_privacy_repository.dart';

class SetDefaultDisappearTimerUseCase {
  final AutoDisappearMassagesPrivacyRepository repository;
  final FirebaseAuth auth;

  SetDefaultDisappearTimerUseCase({
    required this.repository,
    required this.auth,
  });

  Future<void> call(String timer) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    await repository.setDefaultDisappearTimer(uid, timer);
  }
}
