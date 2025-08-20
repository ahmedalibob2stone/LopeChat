import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/datasource/privacy/group/group_privacy_remote_datasource.dart';
import '../../../../../data/repository/privacy/group/group_privacy_repository_impl.dart';
import '../../../../../domain/usecases/privacy/group/get_group_privacy_usecase.dart';

final GetGroupPrivacyUseCaseProvider =
Provider<GetGroupPrivacyUseCase>((ref) {
  final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
    return FirebaseFirestore.instance;
  });
  final firestore = ref.read(firebaseFirestoreProvider); // يجب تعريفه مسبقاً
  final auth = FirebaseAuth.instance;

  final remote = GroupPrivacyRemoteDataSourceImpl(
    firestore: firestore,
  );

  final repository = GroupPrivacyRepositoryImpl(
    remoteDataSource: remote,
  );

  return GetGroupPrivacyUseCase(
    repository: repository,
    auth: auth,
  );
});