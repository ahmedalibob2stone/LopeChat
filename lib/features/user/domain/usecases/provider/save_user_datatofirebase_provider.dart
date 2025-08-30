import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/user_repository.dart';
import '../save_user_DataToFirebase_UseCase.dart';

final saveUserDataToFirebaseUseCaseProvider = Provider<SaveUserDataToFirebaseUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return SaveUserDataToFirebaseUseCase(repo);
});