import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/user_info_viewmodel.dart';
import '../usecases/get_my_data_stream_usecase_provider.dart';
import '../usecases/save_user_data_to_firebase_usecase_provider.dart';
import '../usecases/update_profile_image_usecase_provider.dart';
import '../usecases/update_user_name_usecase_provider.dart';
import '../usecases/update_user_statu_usecase_provider.dart';

final UserInfoViewModelProvider =
StateNotifierProvider<UserInfoViewModel, UserInfoState>((ref) {
  final getMyDataStreamUseCase = ref.read(getMyDataStreamUseCaseProvider);
  final updateUserNameUseCase = ref.read(updateUserNameUseCaseProvider);
  final updateUserStatusUseCase = ref.read(updateUserStatusUseCaseProvider);
  final updateProfileImageUseCase = ref.read(updateProfileImageUseCaseProvider);
  final SaveUserDataToFirebaseUseCase=ref.read(saveUserDataToFirebaseUseCaseProvider);

  return UserInfoViewModel(
    getMyDataStreamUseCase,
    updateUserNameUseCase,
    updateUserStatusUseCase,
    updateProfileImageUseCase,
  SaveUserDataToFirebaseUseCase
  );
});
