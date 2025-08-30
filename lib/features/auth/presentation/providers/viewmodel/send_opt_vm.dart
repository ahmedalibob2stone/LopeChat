import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/send_otp_viewmodel.dart';
import '../usecase/send_opt_usecase_provider.dart';

final sendOtpViewModelProvider = StateNotifierProvider<SendOtpViewModel, SendOtpState>((ref) {
  final sendOtpUseCase = ref.watch(sendOtpUseCaseProvider);
  return SendOtpViewModel(sendOtpUseCase);
});