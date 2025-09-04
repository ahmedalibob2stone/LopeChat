
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/updateing_profile_viewmodel.dart';
import '../usecases/get_my_data_stream_usecase_provider.dart';
import '../usecases/get_user_by_id_usecase_provider.dart';
import '../usecases/update_profile_image_usecase_provider.dart';
import '../usecases/update_user_name_usecase_provider.dart';
import '../usecases/update_user_statu_usecase_provider.dart';

final UpdateProfileViewModelProvider =
StateNotifierProvider<UpdateProfileViewModel,UserInfoState>((ref) {
  final UpdateUserName = ref.read(updateUserNameUseCaseProvider);
  final UpdateUserStatu = ref.read(updateUserStatusUseCaseProvider);
  final UpdateProfileImage = ref.read(updateProfileImageUseCaseProvider);
  final getUserDataStream = ref.read(getMyDataStreamUseCaseProvider);


  return UpdateProfileViewModel(updateProfileImageUseCase: UpdateProfileImage,
    updateUserStatusUseCase: UpdateUserStatu, updateUserNameUseCase: UpdateUserName,
    getMyDataStreamUseCase:getUserDataStream,
  );
});