import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/user_entity.dart';
import '../domain/usecases/get_current_user_DataUseCase.dart';

import '../domain/usecases/update_profileImageUrl_UseCase.dart';
import '../domain/usecases/upload_profileImage_UseCase.dart';



enum UserInfoStatus { initial, loading, success, error }

class UserInfoState {
  final UserEntity? user;
  final UserInfoStatus status;
  final String? errorMessage;

  const UserInfoState({
    this.user,
    this.status = UserInfoStatus.initial,
    this.errorMessage,
  });

  UserInfoState copyWith({
    UserEntity? user,
    UserInfoStatus? status,
    String? errorMessage,
  }) {
    return UserInfoState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class UpdateProfileImageViewModel extends StateNotifier<UserInfoState> {
  final UploadProfileImageUseCase _uploadProfileImage;
  final UpdateProfileImageUrlUseCase _updateProfileImageUrl;
  final GetCurrentUserDataUseCase _getCurrentUserData;

  UpdateProfileImageViewModel({
    required UploadProfileImageUseCase uploadProfileImage,
    required UpdateProfileImageUrlUseCase updateProfileImageUrl,
    required GetCurrentUserDataUseCase getCurrentUserData,
  })  : _uploadProfileImage = uploadProfileImage,
        _updateProfileImageUrl = updateProfileImageUrl,
        _getCurrentUserData = getCurrentUserData,
        super(const UserInfoState());

  Future<void> updateProfileImage(File? profile) async {
    if (profile == null) return;

    state = state.copyWith(status: UserInfoStatus.loading);

    try {
      final photoUrl = await _uploadProfileImage(profile);

      await _updateProfileImageUrl(photoUrl);

      final updatedUser = await _getCurrentUserData();

      state = state.copyWith(
        user: updatedUser,
        status: UserInfoStatus.success,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: UserInfoStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
