
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/update_user_profile_picture_usecase.dart';
import '../repository/repository_provider.dart';

final updateProfileImageUseCaseProvider = Provider<UpdateProfileImageUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UpdateProfileImageUseCase(repository);
});