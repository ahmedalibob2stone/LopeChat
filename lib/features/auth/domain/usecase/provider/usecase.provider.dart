import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/ datasources/firebase_auth_datasource.dart';
import '../../../data/ repositories/auth_repository_impl.dart';
import '../../repositories/auth_repository.dart';
import '../send_otp_usecase.dart';
import '../verify_otp_usecase.dart';
final authApiDataSourceProvider = Provider<AuthApiDataSource>((ref) {
  const baseUrl = 'https://example.com/api';        // ضع رابط الـ API الحقيقي هنا
  return AuthApiDataSource(baseUrl);
});
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final apiDataSource = ref.read(authApiDataSourceProvider);
  return AuthRepositoryImpl(apiDataSource );
});

final sendOtpUseCaseProvider = Provider<SendOtpUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SendOtpUseCase(repo);
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return VerifyOtpUseCase(repo);
});
