
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/user_repository.dart';
import '../add_status_UseCase.dart';

final addStatusUseCaseProvider = Provider<AddStatusUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider); // هذا هو IUserRepository
  return AddStatusUseCase(repo);
});
