
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/user_repository.dart';
import '../get_current_user_DataUseCase.dart';

final getCurrentUserDataUseCaseProvider = Provider<GetCurrentUserDataUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return GetCurrentUserDataUseCase(repo);
});