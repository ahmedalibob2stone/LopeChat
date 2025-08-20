
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/datasource/privacy/block/block_privacy_remote_datasource_impl.dart';
import '../../../../../data/repository/privacy/block/block_privacy_repository_impl.dart';
import '../../../../../domain/usecases/privacy/block/block_privacy_usecase.dart';

final blockPrivacyRemoteDataSourceProvider = Provider<BlockPrivacyRemoteDataSourceImpl>((ref) {
  return BlockPrivacyRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
  );
});
final blockPrivacyRepositoryProvider = Provider<BlockPrivacyRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(blockPrivacyRemoteDataSourceProvider);
  return BlockPrivacyRepositoryImpl(remoteDataSource);
});
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
final blockPrivacyUserUseCaseProvider = Provider<BlockPrivacyUserUseCase>((ref) {
  final repository = ref.watch(blockPrivacyRepositoryProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return BlockPrivacyUserUseCase(  repository,auth);
});