import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/datasource/account/two step verification/two_step_verification_local_datasource.dart';
import '../../../../../data/repository/account/two step verification/two_step_verification_repository_impl.dart';
import '../../../../../domain/repository/account/two step verification/two_step_verification_repository.dart';
import '../../email/data/provider.dart';


final twoStepVerificationLocalDataSourceProvider = Provider<TwoStepVerificationLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return TwoStepVerificationLocalDataSourceImpl(sharedPreferences);
});
final twoStepVerificationRepositoryProvider = Provider<TwoStepVerificationRepository>((ref) {
  final localDataSource = ref.watch(twoStepVerificationLocalDataSourceProvider);
  return TwoStepVerificationRepositoryImpl( localDataSource: localDataSource);
});