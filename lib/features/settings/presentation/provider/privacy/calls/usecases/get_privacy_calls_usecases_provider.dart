import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../data/datasource/privacy/calls/privacy_calls_remote_datasource.dart';
import '../../../../../data/datasource/privacy/calls/privacy_calls_remote_datasource_Impl.dart';
import '../../../../../data/repository/privacy/calls/privacy_calls_repository_impl.dart';
import '../../../../../domain/usecases/privacy/calls/get_privacy_calls_usecase.dart';
import '../../../../../domain/usecases/privacy/calls/update_privacy_calls_usecase.dart';


final _firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final _authProvider = Provider((ref) => FirebaseAuth.instance);

final _remoteDatasourceProvider = Provider<PrivacyCallsRemoteDatasource>((ref) {
  return PrivacyCallsRemoteDatasourceImpl(
    firestore: ref.read(_firestoreProvider),
  );
});

final _repositoryProvider = Provider((ref) {
  return PrivacyCallsRepositoryImpl(
    remoteDatasource: ref.read(_remoteDatasourceProvider),
  );
});

final getPrivacyCallsUseCaseProvider = Provider((ref) {
  return GetPrivacyCallsUseCase(
    repository: ref.read(_repositoryProvider),
    auth: ref.read(_authProvider),
  );
});

final updatePrivacyCallsUseCaseProvider = Provider((ref) {
  return UpdatePrivacyCallsUseCase(
    repository: ref.read(_repositoryProvider),
    auth: ref.read(_authProvider),
  );
});
