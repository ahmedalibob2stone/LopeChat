

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../user/presentation/provider/usecases/get_curent_user_id_usecase_provider.dart';
import '../../../../viewmodel/privacy/profile/privacy_profile_viewmodel.dart';
import '../usecases/get_profile_privacy_usecase_provider.dart';
import '../usecases/update_profile_privacy_usecase_provider.dart';

final profilePrivacyProvider = StateNotifierProvider<ProfilePhotoPrivacyViewModel, ProfilePhotoPrivacyState>(
      (ref) {
    final getUseCase = ref.watch(getProfilePrivacyUseCaseProvider);
    final updateUseCase = ref.watch(updateProfilePrivacyUseCaseProvider);
    final getcurentuserid= ref.watch(getCurrentUserIdUseCaseProvider);
    return ProfilePhotoPrivacyViewModel(getUseCase: getUseCase, updateUseCase:
    updateUseCase, getCurrentUserIdUseCase: getcurentuserid);
  },
);
final profilePrivacyForUserProvider = StateNotifierProvider.family<
    ProfilePhotoPrivacyViewModel, ProfilePhotoPrivacyState, String>(
      (ref, userId) {
    final getUseCase = ref.watch(getProfilePrivacyUseCaseProvider);
    final updateUseCase = ref.watch(updateProfilePrivacyUseCaseProvider);
    final getCurrentUserId = ref.watch(getCurrentUserIdUseCaseProvider);
    final vm = ProfilePhotoPrivacyViewModel(
      getUseCase: getUseCase,
      updateUseCase: updateUseCase,
      getCurrentUserIdUseCase: getCurrentUserId,
    );

    return vm;
  },
);

