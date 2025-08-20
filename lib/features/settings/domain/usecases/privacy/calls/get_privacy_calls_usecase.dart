import 'package:firebase_auth/firebase_auth.dart';
import '../../../entities/privacy/calls/privacy_calls_entity.dart';
import '../../../repository/privacy/calls/privacy_calls_repository.dart';

class GetPrivacyCallsUseCase {
  final PrivacyCallsRepository repository;
  final FirebaseAuth auth;

  GetPrivacyCallsUseCase({
    required this.repository,
    required this.auth,
  });

  Future<PrivacyCallsEntity> call() async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not authenticated");
    final uid = user.uid;
    return await repository.getPrivacyCalls(uid);
  }
}
