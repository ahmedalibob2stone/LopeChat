import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/user_repository.dart';
import '../domain/entities/user_entity.dart';
import '../domain/usecases/provider/get_user_data_by_id_provider.dart';
import '../domain/usecases/provider/get_user_datastream_provider.dart';
import '../model/user_model/user_model.dart';
final userByIdProvider = StreamProvider.family<UserEntity, String>((ref, userId) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.userData(userId); // يرجع Stream<UserEntity>
});

final serByIdProvider = StreamProvider.family<UserEntity, String>((ref, userId) {
  final useCase = ref.watch(getUserDataStreamUseCaseProvider);
  return useCase(userId);
});

final currentUserViewModelProvider = StreamProvider.autoDispose<UserEntity>((ref) {
  final getUserById = ref.watch(getUserByIdUseCaseProvider);
  final getCurrentUid = ref.watch(getCurrentUserIdUseCaseProvider);

  final uid = getCurrentUid();
  return getUserById.execute(uid);
});

