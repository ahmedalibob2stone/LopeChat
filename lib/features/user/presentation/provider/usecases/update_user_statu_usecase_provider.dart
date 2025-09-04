
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/update_user_status_usecase.dart';
import '../repository/repository_provider.dart';

final updateUserStatusUseCaseProvider = Provider<UpdateUserStatusUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UpdateUserStatusUseCase(repository);
});
