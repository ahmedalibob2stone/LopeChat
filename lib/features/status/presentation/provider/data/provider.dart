import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../storsge/repository.dart';
import '../../../data/datasources/status_remote_data_source.dart';
import '../../../data/repositories/status_repository_impl.dart';
import '../../../domain/repositories/status_repository.dart';

final statusRemoteDataSourceProvider = Provider<StatusRemoteDataSource>((ref) {
  return StatusRemoteDataSource(
    fire: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
    storageRepo: ref.read(FirebaseStorageRepositoryProvider),
  );
});
final statusRepositoryImplProvider = Provider<IStatusRepository>((ref) {
  final remoteDataSource = ref.read(statusRemoteDataSourceProvider);
  return StatusRepositoryImpl(remoteDataSource);
});
