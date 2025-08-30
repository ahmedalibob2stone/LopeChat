

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/user_repository.dart';
import '../../get_curent_user_usecase.dart';
import '../../get_myDataStream_UseCase.dart';
import '../../get_user_DataStream_UseCase.dart';
import '../../update_user_name_usecase.dart';
import '../../update_user_profile_picture_usecase.dart';
import '../../update_user_status_usecase.dart';

final UpdateUserNameUseCaseProvider = Provider<UpdateUserNameUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return UpdateUserNameUseCase(repo);
});
final UpdateUserStatusCaseProvider = Provider<UpdateUserStatusUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return UpdateUserStatusUseCase(repo);
});
final UpdateProfileImageCaseProvider = Provider<UpdateProfileImageUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return UpdateProfileImageUseCase(repo);
});
final getUserDataStreamUseCaseProvider = Provider<GetMyDataStreamUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return GetMyDataStreamUseCase(repo);
});
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});