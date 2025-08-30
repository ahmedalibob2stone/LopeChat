import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../../domain/usecases/account/twostepverfication/clear_two_step_verification_usecase.dart';
import '../../../../../domain/usecases/account/twostepverfication/get_pin_usecase.dart';
import '../../../../../domain/usecases/account/twostepverfication/get_recovery_email_usecase.dart';
import '../../../../../domain/usecases/account/twostepverfication/get_two_step_status_usecase.dart';
import '../../../../../domain/usecases/account/twostepverfication/set_pin_usecase.dart';
import '../../../../../domain/usecases/account/twostepverfication/set_recovery_email_usecase.dart';
import '../../../../../domain/usecases/account/twostepverfication/set_two_step_status_usecase.dart';
import '../data/provider.dart';



final getTwoStepStatusUseCaseProvider = Provider<GetTwoStepStatusUseCase>((ref) {
  final repo = ref.watch(twoStepVerificationRepositoryProvider);
  return GetTwoStepStatusUseCase(repo);
});

final setTwoStepStatusUseCaseProvider = Provider<SetTwoStepStatusUseCase>((ref) {
  final repo = ref.watch(twoStepVerificationRepositoryProvider);
  return SetTwoStepStatusUseCase(repo);
});

final getPinUseCaseProvider = Provider<GetPinUseCase>((ref) {
  final repo = ref.watch(twoStepVerificationRepositoryProvider);
  return GetPinUseCase(repo);
});

final setPinUseCaseProvider = Provider<SetPinUseCase>((ref) {
  final repo = ref.watch(twoStepVerificationRepositoryProvider);
  return SetPinUseCase(repo);
});

final getRecoveryEmailUseCaseProvider = Provider<GetRecoveryEmailUseCase>((ref) {
  final repo = ref.watch(twoStepVerificationRepositoryProvider);
  return GetRecoveryEmailUseCase(repo);
});

final setRecoveryEmailUseCaseProvider = Provider<SetRecoveryEmailUseCase>((ref) {
  final repo = ref.watch(twoStepVerificationRepositoryProvider);
  return SetRecoveryEmailUseCase(repo);
});

final clearTwoStepVerificationUseCaseProvider = Provider<ClearTwoStepVerificationUseCase>((ref) {
  final repo = ref.watch(twoStepVerificationRepositoryProvider);
  return ClearTwoStepVerificationUseCase(repo);
});
