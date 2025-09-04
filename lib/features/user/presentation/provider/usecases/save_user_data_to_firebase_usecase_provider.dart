


import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/save_user_data_to_firebase_usecase.dart';
import '../repository/repository_provider.dart';

final saveUserDataToFirebaseUseCaseProvider = Provider<SaveUserDataToFirebaseUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return SaveUserDataToFirebaseUseCase(repository);
});
