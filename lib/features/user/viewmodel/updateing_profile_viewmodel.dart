import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/user_entity.dart';

import '../domain/usecases/get_myDataStream_UseCase.dart';
import '../domain/usecases/update_user_name_usecase.dart';
import '../domain/usecases/update_user_profile_picture_usecase.dart';
import '../domain/usecases/update_user_status_usecase.dart';
import '../domain/usecases/upload_profileImage_UseCase.dart';



enum UserInfoStatus { initial, loading, SuccessfulUpdate, errorUpdate, }

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

class UpdateProfileViewModel extends StateNotifier<UserInfoState> {
  final UpdateProfileImageUseCase _updateProfileImageUseCase;
  final UpdateUserStatusUseCase _updateUserStatusUseCase;
  final UpdateUserNameUseCase _updateUserNameUseCase;
  final GetMyDataStreamUseCase _getMyDataStreamUseCase;
  StreamSubscription<UserEntity?>? _userStreamSubscription;


  UpdateProfileViewModel( {
    required UpdateProfileImageUseCase updateProfileImageUseCase,
    required UpdateUserStatusUseCase updateUserStatusUseCase,
    required UpdateUserNameUseCase updateUserNameUseCase,
    required GetMyDataStreamUseCase getMyDataStreamUseCase,
  })  : _updateProfileImageUseCase = updateProfileImageUseCase,
        _updateUserStatusUseCase = updateUserStatusUseCase,
        _updateUserNameUseCase = updateUserNameUseCase,
        _getMyDataStreamUseCase = getMyDataStreamUseCase,
        super(const UserInfoState());

  Future<void> updateProfileImage(File? profile) async {
    if (profile == null) return;

    state = state.copyWith(status: UserInfoStatus.loading);

    try {
      await _updateProfileImageUseCase(profile);
      state = state.copyWith(
        status: UserInfoStatus.SuccessfulUpdate,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: UserInfoStatus.errorUpdate,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateUserName(String name) async {
    try {
      state = state.copyWith(status: UserInfoStatus.loading);
      await _updateUserNameUseCase(name);
      state = state.copyWith(status: UserInfoStatus.SuccessfulUpdate);
    } catch (e) {
      state = state.copyWith(
        status: UserInfoStatus.errorUpdate,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateUserStatu(String statu) async {
    try {
      state = state.copyWith(status: UserInfoStatus.loading);
      await _updateUserStatusUseCase(statu);
      state = state.copyWith(status: UserInfoStatus.SuccessfulUpdate);
    } catch (e) {
      state = state.copyWith(
        status: UserInfoStatus.errorUpdate,
        errorMessage: e.toString(),
      );
    }
  }

  void listenToUserStream() {
    _userStreamSubscription?.cancel();

    _userStreamSubscription = _getMyDataStreamUseCase().listen(
          (userEntity) {
        state = state.copyWith(
          user: userEntity,
          status: UserInfoStatus.SuccessfulUpdate,
          errorMessage: null,
        );
      },
      onError: (e) {
        state = state.copyWith(
          status: UserInfoStatus.errorUpdate,
          errorMessage: e.toString(),
        );
      },
    );
  }


  @override
  void dispose() {
    _userStreamSubscription?.cancel(); // مهم جدًا لتجنب تسرب الذاكرة
    super.dispose();
  }
}
