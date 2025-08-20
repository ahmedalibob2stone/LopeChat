import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../data/datasource/account/delet account/delet_account_remote_datasorce.dart';
import '../../../../../data/repository/account/delet account/delete_account_repository_impl.dart';
import '../../../../../domain/repository/account/delet account/delete_account_repository.dart';


final deleteAccountRemoteDataSourceProvider = Provider<DeleteAccountRemoteDataSource>((ref) {
  return DeleteAccountRemoteDataSource(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});


final deleteAccountRepositoryProvider = Provider<DeleteAccountRepository>((ref) {
  final remoteDataSource = ref.watch(deleteAccountRemoteDataSourceProvider);
  return DeleteAccountRepositoryImpl(remoteDataSource);
});
