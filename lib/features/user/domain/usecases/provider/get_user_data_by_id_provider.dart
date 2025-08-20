import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/user_repository.dart';
import '../../entities/user_entity.dart';
import '../get_current_user_id_usecase.dart';
import '../get_user_by_id_usecase.dart';
final getUserByIdUseCaseProvider = Provider<GetUserByIdUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserByIdUseCase(repository);
});


final userDataProvider = StreamProvider.family<UserEntity, String>((ref, uid) {
  final useCase = ref.watch(getUserByIdUseCaseProvider);
  return useCase.execute(uid);
});
final getCurrentUserIdUseCaseProvider = Provider<GetCurrentUserIdUseCase>((ref) {
  return GetCurrentUserIdUseCase(FirebaseAuth.instance);
});
