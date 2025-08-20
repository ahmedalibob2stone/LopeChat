
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/provider/usecase/provider.dart';
import '../../viewmodel/updateing_profile_viewmodel.dart';

final UpdateProfileViewModelProvider =
StateNotifierProvider<UpdateProfileViewModel,UserInfoState>((ref) {
  final UpdateUserName = ref.read(UpdateUserNameUseCaseProvider);
  final UpdateUserStatu = ref.read(UpdateUserStatusCaseProvider);
  final UpdateProfileImage = ref.read(UpdateProfileImageCaseProvider);
  final getUserDataStream = ref.read(getUserDataStreamUseCaseProvider);


  return UpdateProfileViewModel(updateProfileImageUseCase: UpdateProfileImage,
      updateUserStatusUseCase: UpdateUserStatu, updateUserNameUseCase: UpdateUserName,
    getMyDataStreamUseCase:getUserDataStream,
  );
});