import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/user_repository.dart';
import '../set_user_StateUseCase.dart';

final setUserStateUseCaseProvider = Provider<SetUserStateUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return SetUserStateUseCase(repo);
});
