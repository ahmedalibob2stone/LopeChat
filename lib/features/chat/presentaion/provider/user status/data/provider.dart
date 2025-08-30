

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasorce/user_status_remote_data_source.dart';
import '../../../../data/repository/user_status_repository.dart';

final userstatusRemoteDataSourceProvider = Provider<UserStatusRemoteDataSource>((ref) {
  final firestore = FirebaseFirestore.instance;
  return UserStatusRemoteDataSource(firestore);
});

final userStatusRepositoryProvider = Provider<UserStatusRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(userstatusRemoteDataSourceProvider);
  return UserStatusRepositoryImpl(remoteDataSource: remoteDataSource);
});
