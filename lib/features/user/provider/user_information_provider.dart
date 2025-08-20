import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/user_entity.dart';
import '../domain/usecases/provider/get_current_userdata_provider.dart';
import '../domain/usecases/provider/save_user_datatofirebase_provider.dart';
import '../viewmodel/user_information_viewmodel.dart';



final userInformationViewModelProvider =
StateNotifierProvider<UserInformationViewModel, AsyncValue<UserEntity?>>((ref) {
  final getUserData = ref.read(getCurrentUserDataUseCaseProvider);
  final saveUserData = ref.read(saveUserDataToFirebaseUseCaseProvider);

  return UserInformationViewModel(
    getUserDataUseCase: getUserData,
    saveUserDataUseCase: saveUserData,
  );
});
