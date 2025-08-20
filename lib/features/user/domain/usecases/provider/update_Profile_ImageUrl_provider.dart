
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/user_repository.dart';
import '../update_profileImageUrl_UseCase.dart';

final updateProfileImageUrlUseCaseProvider = Provider<UpdateProfileImageUrlUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider); // IUserRepository
  return UpdateProfileImageUrlUseCase(repo);
});