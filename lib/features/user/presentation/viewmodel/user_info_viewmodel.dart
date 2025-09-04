import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/widgets/check internat/check_internat.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_my_data_stream_usecase.dart';
import '../../domain/usecases/update_user_name_usecase.dart';
import '../../domain/usecases/update_user_status_usecase.dart';
import '../../domain/usecases/update_user_profile_picture_usecase.dart';
import '../../domain/usecases/save_user_data_to_firebase_usecase.dart';

class UserInfoState {
  final UserEntity? user;
  final bool isLoading;
  final String? nameError;
  final String? statusError;
  final String? imageError;

  const UserInfoState({
    this.user,
    this.isLoading = false,
    this.nameError,
    this.statusError,
    this.imageError,
  });

  UserInfoState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? nameError,
    String? statusError,
    String? imageError,
  }) {
    return UserInfoState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      nameError: nameError,
      statusError: statusError,
      imageError: imageError,
    );
  }
}

class UserInfoViewModel extends StateNotifier<UserInfoState> {
  final GetMyDataStreamUseCase _getMyDataStreamUseCase;
  final UpdateUserNameUseCase _updateUserNameUseCase;
  final UpdateUserStatusUseCase _updateUserStatusUseCase;
  final UpdateProfileImageUseCase _updateProfileImageUseCase;
  final SaveUserDataToFirebaseUseCase _saveUserDataToFirebaseUseCase;

  StreamSubscription<UserEntity?>? _userSubscription;

  UserInfoViewModel(
      this._getMyDataStreamUseCase,
      this._updateUserNameUseCase,
      this._updateUserStatusUseCase,
      this._updateProfileImageUseCase,
      this._saveUserDataToFirebaseUseCase,
      ) : super(const UserInfoState()) {
    _init();
  }

  void _init() {
    _userSubscription = _getMyDataStreamUseCase().listen(
          (user) {
        state = state.copyWith(user: user, isLoading: false);
      },
      onError: (e) {
        state = state.copyWith(
          nameError: "Failed to load user data",
          isLoading: false,
        );
      },
    );
  }


    String _mapExceptionToMessage(dynamic e) {
      if (e is TimeoutException) return "Connection timeout. Please try again.";
      if (e is SocketException) return "No internet connection. Please check your network.";
      if (e is FirebaseException) return e.message ?? "Firebase error occurred.";

      return "Unexpected error occurred. Please try again.";
  }

  Future<void> updateName(String name) async {
    if (!await CheckInternet.isConnected()) {
      state = state.copyWith(nameError: "Network error: please check your connection");
      return;
    }

    state = state.copyWith(isLoading: true, nameError: null);
    try {
      await _updateUserNameUseCase(name);
    } catch (e) {
      state = state.copyWith(nameError: _mapExceptionToMessage(e));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateStatus(String status) async {
    if (!await CheckInternet.isConnected()) {
      state = state.copyWith(statusError: "Network error: please check your connection");
      return;
    }

    state = state.copyWith(isLoading: true, statusError: null);
    try {
      await _updateUserStatusUseCase(status);
    } catch (e) {
      state = state.copyWith(nameError: _mapExceptionToMessage(e));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateProfileImage(dynamic file) async {
    if (!await CheckInternet.isConnected()) {
      state = state.copyWith(imageError: "Network error: please check your connection");
      return;
    }

    File? imageFile;
    if (file is XFile) imageFile = File(file.path);
    if (file is! File && file is! XFile) {
      state = state.copyWith(imageError: "Invalid file type");
      return;
    }

    state = state.copyWith(isLoading: true, imageError: null);
    try {
      await _updateProfileImageUseCase(imageFile!);
    } catch (e) {
      state = state.copyWith(nameError: _mapExceptionToMessage(e));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> saveUserData({
    required String name,
    required File? profile,
    required String statu,
  }) async {
    if (!await CheckInternet.isConnected()) {
      state = state.copyWith(nameError: "Network error: please check your connection");
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      await _saveUserDataToFirebaseUseCase(
        name: name,
        profile: profile,
        statu: statu,
      );
    } catch (e) {
      state = state.copyWith(nameError: _mapExceptionToMessage(e));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
