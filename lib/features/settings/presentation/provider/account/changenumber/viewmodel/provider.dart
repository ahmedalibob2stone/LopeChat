import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/acount/change number/change_number_view_model.dart';
import '../usecase/provider.dart';



final changeNumberViewModelProvider =
StateNotifierProvider<ChangeNumberViewModel, ChangeNumberState>((ref) {
  return ChangeNumberViewModel(
    verifyOldPhoneNumberUseCase: ref.read(verifyOldPhoneNumberUseCaseProvider),
    verifyNewPhoneNumberUseCase: ref.read(verifyNewPhoneNumberUseCaseProvider),
    signInWithCredentialUseCase: ref.read(signInWithPhoneCredentialUseCaseProvider),
    updatePhoneNumberUseCase: ref.read(updatePhoneNumberUseCaseProvider),
  );
});
