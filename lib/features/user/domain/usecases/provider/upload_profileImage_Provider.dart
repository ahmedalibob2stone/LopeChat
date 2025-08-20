import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/user_repository.dart';
import '../upload_profileImage_UseCase.dart';

final uploadProfileImageUseCaseProvider = Provider<UploadProfileImageUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider); // IUserRepository
  return UploadProfileImageUseCase(repo);
});