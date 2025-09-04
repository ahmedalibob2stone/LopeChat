import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_entity.dart';
import '../repository/repository_provider.dart';
import '../usecases/get_my_data_stream_usecase_provider.dart';
import '../usecases/get_user_by_id_usecase_provider.dart';

/// Stream لمستخدم الحالي
final currentUserStreamProvider = StreamProvider<UserEntity?>((ref) {
  final getMyDataUseCase = ref.watch(getMyDataStreamUseCaseProvider);
  return getMyDataUseCase(); // Stream<UserEntity?>
});

final userByIdStreamProvider = StreamProvider.family<UserEntity, String>((ref, uid) {
  final getUserByIdUseCase = ref.watch(getUserByIdUseCaseProvider);
  return getUserByIdUseCase.call(uid);
});
final otherUserStreamProvider =
StreamProvider.family<UserEntity?, String>((ref, userId) {
  final userRepo = ref.watch(userRepositoryProvider);
  return userRepo.getUserById(userId); // Stream<UserEntity>
});
