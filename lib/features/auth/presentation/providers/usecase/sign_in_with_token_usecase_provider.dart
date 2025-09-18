import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/ datasources/api_datasorce.dart';
import '../../../data/ repositories/auth_repository_impl.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecase/sign_in_with_token_usecase.dart';


final authApiDataSourceProvider = Provider<AuthApiDataSource>((ref) {
  final String baseUrl = 'https://lopechat.onrender.com';

  return AuthApiDataSource( baseUrl: baseUrl);
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final apiDataSource = ref.watch(authApiDataSourceProvider);
  return AuthRepositoryImpl(apiDataSource);
});



final signInWithTokenUseCaseProvider = Provider<SignInWithTokenUseCase>((ref) {
  return SignInWithTokenUseCase(FirebaseAuth.instance);

});
