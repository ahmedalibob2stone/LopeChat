import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_curent_user_data_usecase.dart';
import '../../domain/usecases/save_user_data_to_firebase_usecase.dart';


class UserInformationViewModel extends StateNotifier<AsyncValue<UserEntity?>> {
  final GetCurrentUserDataUseCase getUserDataUseCase;
  final SaveUserDataToFirebaseUseCase saveUserDataUseCase;

  UserInformationViewModel({
    required this.getUserDataUseCase,
    required this.saveUserDataUseCase,
  }) : super(const AsyncValue.loading()) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await getUserDataUseCase();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> reloadUser() async {
    state = const AsyncValue.loading();
    await _loadCurrentUser();
  }

  Future<void> saveUserInfo({
    required String name,
    required String statu,
    required File? profile,
  }) async {
    try {
      state = const AsyncValue.loading();
      await saveUserDataUseCase(name: name, statu: statu, profile: profile);
      await reloadUser();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
