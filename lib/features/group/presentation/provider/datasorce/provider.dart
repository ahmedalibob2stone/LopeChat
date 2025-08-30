import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../storsge/repository.dart';
import '../../../data/datasource/group_remote_data_source.dart';
import '../../../data/repository/group_repository_impl.dart';
import '../../../domain/repository/group_repository.dart';

final groupRemoteDataSourceProvider = Provider<GroupRemoteDataSource>((ref) {
  return GroupRemoteDataSource(
    fire: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    storageRepository: ref.read(FirebaseStorageRepositoryProvider),
  );
});

final groupRepositoryProvider = Provider<IGroupRepository>((ref) {
  final remoteDataSource = ref.read(groupRemoteDataSourceProvider);
  return GroupRepositoryImpl(remoteDataSource: remoteDataSource, firestore: FirebaseFirestore.instance);
});
