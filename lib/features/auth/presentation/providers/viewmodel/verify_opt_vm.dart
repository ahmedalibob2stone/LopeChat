import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/send_otp_viewmodel.dart';
import '../../viewmodels/verify_opt_viewmodel.dart';
import '../usecase/sign_in_with_token_usecase_provider.dart';
import '../usecase/verify_opt_usecase_provider.dart';

final verifyOtpViewModelProvider = StateNotifierProvider<VerifyOtpViewModel, VerifyOtpState>((ref) {
  final verifyOtpUseCase = ref.watch(verifyOtpUseCaseProvider);
  final signInWithTokenUseCase = ref.watch(signInWithTokenUseCaseProvider);
  return VerifyOtpViewModel(verifyOtpUseCase, signInWithTokenUseCase);
});