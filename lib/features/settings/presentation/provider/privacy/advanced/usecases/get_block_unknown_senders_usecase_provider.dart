import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../../../main.dart';
import '../../../../../data/datasource/privacy/advanced/advanced_privacy_datasource.dart';
import '../../../../../data/datasource/privacy/advanced/advanced_privacy_local_datasorce.dart';
import '../../../../../data/datasource/privacy/advanced/advanced_privacy_remote_datasource_impl.dart';
import '../../../../../data/repository/privacy/advanced/advanced_privacy_repository_impl.dart';
import '../../../../../domain/repository/privacy/advanced/advanced_privacy_repository.dart';
import '../../../../../domain/usecases/privacy/advanced/get_block_unknown_senders.dart';


final advancedPrivacyRemoteDataSourceProvider = Provider<AdvancedPrivacyRemoteDataSource>((ref) {
  return AdvancedPrivacyRemoteDataSourceImpl(firestore: FirebaseFirestore.instance); // إذا كان يحتاج مزودات أخرى، ضفها هنا
});

final advancedPrivacyLocalDataSourceProvider = Provider<AdvancedPrivacyLocalDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AdvancedPrivacyLocalDatasourceImpl( prefs);
});

final advancedPrivacyRepositoryProvider = Provider<AdvancedPrivacyRepository>((ref) {
  final remoteDataSource = ref.watch(advancedPrivacyRemoteDataSourceProvider);
  final localDataSource = ref.watch(advancedPrivacyLocalDataSourceProvider);

  return AdvancedPrivacyRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
final getBlockUnknownSendersUseCaseProvider = Provider<GetBlockUnknownSendersUseCase>((ref) {
  return GetBlockUnknownSendersUseCase(
    repository: ref.watch(advancedPrivacyRepositoryProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});
