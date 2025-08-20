import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/datasource/privacy/group/group_privacy_remote_datasource.dart';
import '../../../../../data/repository/privacy/group/group_privacy_repository_impl.dart';
import '../../../../../domain/usecases/privacy/group/update_group_privacy_usecase.dart';

final UpdateGroupPrivacyUseCaseProvider = Provider<UpdateGroupPrivacyUseCase>((ref) {
  final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
    return FirebaseFirestore.instance;
  });
  final firestore = ref.read(firebaseFirestoreProvider); // تأكد من وجود هذا المزود
  final auth = FirebaseAuth.instance;

  final remote = GroupPrivacyRemoteDataSourceImpl(
    firestore: firestore,
  );

  final repository = GroupPrivacyRepositoryImpl(
    remoteDataSource: remote,
  );

  return UpdateGroupPrivacyUseCase(
    repository: repository,
    auth: auth,
  );
});
