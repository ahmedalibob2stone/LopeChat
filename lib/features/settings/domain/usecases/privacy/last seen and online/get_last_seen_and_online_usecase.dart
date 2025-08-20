import 'package:firebase_auth/firebase_auth.dart';
import '../../../entities/privacy/last seen and online/last_seen_and_online.dart';
import '../../../repository/privacy/last seen and online/privacy_repository.dart';

class GetLastSeenAndOnlineUseCase {
  final LastSeenAndOnlineRepository repository;
  final FirebaseAuth auth;

  GetLastSeenAndOnlineUseCase({
    required this.repository,
    required this.auth,
  });

  Future<LastSeenAndOnlineEntity?> call( String userId ) async {
    if (userId.isEmpty) {
      throw Exception("User ID must not be empty");
    }
    return repository.getLastSeenAndOnlineSettings(userId);
  }
}
