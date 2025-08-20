import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/provider/usecase.provider.dart';
import '../../viewmodels/send_otp_viewmodel.dart';
import '../../viewmodels/verify_opt_viewmodel.dart';
import '../sign_in_with_token_usecase_provider.dart';

final verifyOtpViewModelProvider = StateNotifierProvider<VerifyOtpViewModel, VerifyOtpState>((ref) {
  final verifyOtpUseCase = ref.watch(verifyOtpUseCaseProvider);
  final signInWithTokenUseCase = ref.watch(signInWithTokenUseCaseProvider);
  return VerifyOtpViewModel(verifyOtpUseCase, signInWithTokenUseCase);
});