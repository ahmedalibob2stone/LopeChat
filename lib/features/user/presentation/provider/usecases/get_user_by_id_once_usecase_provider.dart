
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/get_user_by_id_once_usecase.dart';
import '../repository/repository_provider.dart';

final getUserByIdOnceUseCaseProvider = Provider<GetUserByIdOnceUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUserByIdOnceUseCase(repository);
});
