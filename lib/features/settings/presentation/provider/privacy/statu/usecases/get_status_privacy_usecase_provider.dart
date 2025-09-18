import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../data/datasource/privacy/statu/status_privacy_local_datasorce.dart';
import '../../../../../data/datasource/privacy/statu/status_privacy_local_datasorce_impl.dart';
import '../../../../../data/datasource/privacy/statu/status_privacy_remote_datasorce.dart';
import '../../../../../data/datasource/privacy/statu/status_privacy_remote_datasorce_impl.dart';
import '../../../../../data/repository/privacy/statu/status_privacy_repository_impl.dart';
import '../../../../../domain/repository/privacy/statu/status_privacy_repository.dart';
import '../../../../../domain/usecases/privacy/statu/get_status_privacy_usecase.dart';
import 'package:lopechat/main.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// مزود RemoteDataSource
final statusPrivacyRemoteDataSourceProvider = Provider<StatusPrivacyRemoteDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return StatusPrivacyRemoteDataSourceImpl(firestore: firestore);
});

// مزود LocalDataSource
final statusPrivacyLocalDataSourceProvider = Provider<StatusPrivacyLocalDataSource>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return StatusPrivacyLocalDataSourceImpl(sharedPrefs);
});

final statusPrivacyRepositoryProvider = Provider<StatusPrivacyRepository>((ref) {
  final remoteDataSource = ref.watch(statusPrivacyRemoteDataSourceProvider);
  final localDataSource = ref.watch(statusPrivacyLocalDataSourceProvider);
  return StatusPrivacyRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// مزود UseCase
final getStatusPrivacyUseCaseProvider = Provider<GetStatusPrivacyUseCase>((ref) {
  final repository = ref.watch(statusPrivacyRepositoryProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return GetStatusPrivacyUseCase(repository: repository, auth: auth);
});
