import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../data/datasource/privacy/profile/privacy_profile_local_datasource.dart';
import '../../../../../data/datasource/privacy/profile/privacy_profile_remote_datasource.dart';
import '../../../../../data/repository/privacy/profile/privacy_profile_repository_impl.dart';
import '../../../../../domain/repository/privacy/profile/privacy_profile_repository.dart';
import '../../../../../domain/usecases/privacy/profile/update_privacy_profile_settings_usecase.dart';

final profilePrivacyRemoteDataSourceProvider =
Provider<ProfilePrivacyRemoteDataSource>((ref) {
  return ProfilePrivacyRemoteDataSourceImpl(FirebaseFirestore.instance);
});

final profilePrivacyLocalDataSourceProvider =
Provider<ProfilePrivacyLocalDataSource>((ref) {
  return ProfilePrivacyLocalDataSourceImpl();
});

final profilePrivacyRepositoryProvider = Provider<ProfilePrivacyRepository>((ref) {
  final remote = ref.watch(profilePrivacyRemoteDataSourceProvider);
  final local = ref.watch(profilePrivacyLocalDataSourceProvider);
  return ProfilePrivacyRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
});



final updateProfilePrivacyUseCaseProvider = Provider<UpdateProfilePrivacyUseCase>((ref) {
  final repository = ref.watch(profilePrivacyRepositoryProvider);
  final auth = FirebaseAuth.instance;
  return UpdateProfilePrivacyUseCase(repository, auth);
});
