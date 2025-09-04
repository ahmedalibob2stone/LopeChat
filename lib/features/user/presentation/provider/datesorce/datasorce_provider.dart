import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../storsge/repository.dart';
import '../../../data/datasources/user_remote_data_source.dart';

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final storageRepo = ref.read(FirebaseStorageRepositoryProvider);
  return UserRemoteDataSource(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    storageRepository: storageRepo,
  );
});