// presentation/provider/privacy/read_receipts_usecase_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../data/datasource/privacy/read receipts/read_receipts_privacy_remote_datasource.dart';
import '../../../../../data/datasource/privacy/read receipts/read_receipts_remote_datasource_impl.dart';
import '../../../../../data/repository/privacy/read receipts/read_receipts_privacy_repository_impl.dart';
import '../../../../../domain/repository/privacy/read receipts/read_receipts_privacy_repository.dart';
import '../../../../../domain/usecases/privacy/read_receipts/get_read_receipts_usecase.dart';
import '../../../../../domain/usecases/privacy/read_receipts/update_read_receipts_usecase.dart';
import '../data/provider.dart';




final _authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});



final getReadReceiptsUseCaseProvider = Provider<GetReadReceiptsUseCase>((ref) {
  return GetReadReceiptsUseCase(
    repository: ref.watch(readReceiptsRepositoryProvider),
    auth: ref.watch(_authProvider),
  );
});

final updateReadReceiptsUseCaseProvider =
Provider<UpdateReadReceiptsUseCase>((ref) {
  return UpdateReadReceiptsUseCase(
    repository: ref.watch(readReceiptsRepositoryProvider),
    auth: ref.watch(_authProvider),
  );
});
