import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/acount/email/email_viewmodel.dart';
import '../usecases/provider.dart';

final emailEditViewModelProvider = StateNotifierProvider<EmailEditViewModel, EmailEditState>((ref) {
  final getEmailUseCase = ref.watch(getEmailUseCaseProvider);
  final setEmailUseCase = ref.watch(setEmailUseCaseProvider);
  return EmailEditViewModel(
    getEmailUseCase: getEmailUseCase,
    setEmailUseCase: setEmailUseCase,
  );
});
