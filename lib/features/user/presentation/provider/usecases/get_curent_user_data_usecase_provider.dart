import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/get_curent_user_data_usecase.dart';
import '../../../domain/usecases/get_curent_user_id_usecase.dart';
import '../../../domain/usecases/get_user_by_id_once_usecase.dart';
import '../repository/repository_provider.dart';

final getCurrentUserIdUseCaseProvider = Provider<GetCurrentUserIdUseCase>((ref) {
  return GetCurrentUserIdUseCase(FirebaseAuth.instance);
});

final getUserByIdOnceUseCaseProvider = Provider<GetUserByIdOnceUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUserByIdOnceUseCase(repository);
});

final getCurrentUserDataUseCaseProvider = Provider<GetCurrentUserDataUseCase>((ref) {
  final getUserByIdOnce = ref.read(getUserByIdOnceUseCaseProvider);
  return GetCurrentUserDataUseCase( getUserByIdOnce);
});
