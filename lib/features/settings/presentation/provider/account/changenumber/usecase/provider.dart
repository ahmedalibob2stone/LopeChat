import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/usecases/account/change_number/sign_In_with_phone_credential_use_case.dart';
import '../../../../../domain/usecases/account/change_number/update_phone_number_useCase.dart';
import '../../../../../domain/usecases/account/change_number/verify_new_phone_number_usecase.dart';
import '../../../../../domain/usecases/account/change_number/verify_old_phone_number_usecase dart.dart';
import '../data/provider.dart';

final verifyOldPhoneNumberUseCaseProvider = Provider<VerifyOldPhoneNumberUseCase>((ref) {
  final repository = ref.watch(changeNumberRepositoryProvider);
  return VerifyOldPhoneNumberUseCase(repository);
});

final verifyNewPhoneNumberUseCaseProvider = Provider<VerifyNewPhoneNumberUseCase>((ref) {
  final repository = ref.watch(changeNumberRepositoryProvider);
  return VerifyNewPhoneNumberUseCase(repository);
});

final signInWithPhoneCredentialUseCaseProvider = Provider<SignInWithPhoneCredentialUseCase>((ref) {
  final repository = ref.watch(changeNumberRepositoryProvider);
  return SignInWithPhoneCredentialUseCase(repository);
});

final updatePhoneNumberUseCaseProvider = Provider<UpdatePhoneNumberUseCase>((ref) {
  final repository = ref.watch(changeNumberRepositoryProvider);
  return UpdatePhoneNumberUseCase(repository);
});
