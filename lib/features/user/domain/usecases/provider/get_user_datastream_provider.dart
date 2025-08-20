import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/user_repository.dart';
import '../get_user_DataStream_UseCase.dart';

final getUserDataStreamUseCaseProvider = Provider<GetUserDataStreamUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return GetUserDataStreamUseCase(repo);
});
