import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/datasource/privacy/read receipts/read_receipts_privacy_remote_datasource.dart';
import '../../../../../data/datasource/privacy/read receipts/read_receipts_remote_datasource_impl.dart';
import '../../../../../data/repository/privacy/read receipts/read_receipts_privacy_repository_impl.dart';
import '../../../../../domain/repository/privacy/read receipts/read_receipts_privacy_repository.dart';

final _firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
final readReceiptsRemoteDatasourceProvider =
Provider<ReadReceiptsRemoteDatasource>((ref) {
  return ReadReceiptsRemoteDatasourceImpl(
    firestore: ref.watch(_firestoreProvider),
  );
});

final readReceiptsRepositoryProvider = Provider<ReadReceiptsRepository>((ref) {
  return ReadReceiptsRepositoryImpl(
    remoteDatasource: ref.watch(readReceiptsRemoteDatasourceProvider),
  );
});