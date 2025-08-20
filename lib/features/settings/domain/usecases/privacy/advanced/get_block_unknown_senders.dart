// lib/features/privacy/domain/usecases/get_advanced_privacy_settings_usecase.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../../../entities/privacy/advanced/advanced_privacy_entity.dart';
import '../../../repository/privacy/advanced/advanced_privacy_repository.dart';

class GetBlockUnknownSendersUseCase {
  final AdvancedPrivacyRepository repository;
  final FirebaseAuth firebaseAuth;

  GetBlockUnknownSendersUseCase({
    required this.repository,
    required this.firebaseAuth,
  });

  Future<AdvancedPrivacyEntity> call() async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return await repository.getBlockUnknownSenders(user.uid);
  }
}
