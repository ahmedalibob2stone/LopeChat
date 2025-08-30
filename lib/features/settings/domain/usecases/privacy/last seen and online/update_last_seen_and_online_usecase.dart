import 'package:firebase_auth/firebase_auth.dart';

import '../../../entities/privacy/last seen and online/last_seen_and_online.dart';
import '../../../repository/privacy/last seen and online/privacy_repository.dart';

class UpdateLastSeenAndOnlineUseCase {
  final LastSeenAndOnlineRepository repository;
  final FirebaseAuth auth;

  UpdateLastSeenAndOnlineUseCase({
    required this.repository,
    required this.auth,
  });

  Future<void> call(LastSeenAndOnlineEntity entity) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }
    await repository.saveLastSeenAndOnlineSettings(entity, user.uid);
  }
}
