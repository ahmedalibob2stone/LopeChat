

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/get_user_by_id_usecase.dart';
import '../repository/repository_provider.dart';

final getUserByIdUseCaseProvider = Provider<GetUserByIdUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUserByIdUseCase(repository);
});