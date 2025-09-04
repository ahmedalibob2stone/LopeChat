import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/update_user_name_usecase.dart';
import '../repository/repository_provider.dart';

final updateUserNameUseCaseProvider = Provider<UpdateUserNameUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UpdateUserNameUseCase(repository);
});
