import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/usecases/account/email/clear_email_usecase.dart';
import '../../../../../domain/usecases/account/email/get_email_usecase.dart';
import '../../../../../domain/usecases/account/email/set_email_usecase.dart';
import '../data/provider.dart';

final getEmailUseCaseProvider = Provider<GetEmailUseCase>((ref) {
  final repo = ref.watch(emailRepositoryProvider);
  return GetEmailUseCase(repo);
});

final setEmailUseCaseProvider = Provider<SetEmailUseCase>((ref) {
  final repo = ref.watch(emailRepositoryProvider);
  return SetEmailUseCase(repo);
});

final clearEmailUseCaseProvider = Provider<ClearEmailUseCase>((ref) {
  final repo = ref.watch(emailRepositoryProvider);
  return ClearEmailUseCase(repo);
});
