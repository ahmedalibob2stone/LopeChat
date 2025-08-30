import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/user_repository.dart';
import '../domain/usecases/provider/get_current_userdata_provider.dart';
import '../domain/usecases/provider/update_Profile_ImageUrl_provider.dart';
import '../domain/usecases/provider/upload_profileImage_Provider.dart';
import '../viewmodel/update_profile_image_viewmodel.dart';

final updateProfileImageViewModelProvider =
StateNotifierProvider<UpdateProfileImageViewModel, UserInfoState>((ref) {
  final uploadUseCase = ref.read(uploadProfileImageUseCaseProvider);
  final updateUrlUseCase = ref.read(updateProfileImageUrlUseCaseProvider);
  final getUserUseCase = ref.read(getCurrentUserDataUseCaseProvider);

  return UpdateProfileImageViewModel(
    uploadProfileImage: uploadUseCase,
    updateProfileImageUrl: updateUrlUseCase,
    getCurrentUserData: getUserUseCase,
  );
});
