import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/provider/usecase.provider.dart';
import '../../viewmodels/send_otp_viewmodel.dart';

final sendOtpViewModelProvider = StateNotifierProvider<SendOtpViewModel, SendOtpState>((ref) {
  final sendOtpUseCase = ref.watch(sendOtpUseCaseProvider);
  return SendOtpViewModel(sendOtpUseCase);
});