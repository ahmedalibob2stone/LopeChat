import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/ datasources/api_datasorce.dart';
import '../../../data/ repositories/auth_repository_impl.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecase/verify_otp_usecase.dart';

final authApiDataSourceProvider = Provider<AuthApiDataSource>((ref) {
  return AuthApiDataSource('https://your-api-base-url.com');
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final apiDataSource = ref.watch(authApiDataSourceProvider);
  return AuthRepositoryImpl(apiDataSource);
});


final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyOtpUseCase(repository);
});