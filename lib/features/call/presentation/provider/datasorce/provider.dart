import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasorce/call_remote_datasource.dart';
import '../../../data/repository/call_repository_impl.dart';
import '../../../domain/repository/call_repository.dart';

final callRemoteDataSourceProvider = Provider<CallRemoteDataSource>((ref) {
  return CallRemoteDataSource(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final callRepositoryProvider = Provider<CallRepository>((ref) {
  final remoteDataSource = ref.watch(callRemoteDataSourceProvider);
  return CallRepositoryImpl(remoteDataSource);
});