import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../data/datasource/privacy/auto disappear message/auto_disappear_privacy_remote_datasorce.dart';
import '../../../../../data/repository/privacy/auto disappear message/auto_disappear_messages_privacy_repository_impl.dart';
import '../../../../../domain/usecases/privacy/auto disappear message/get_default_disappear_timer_usecase.dart';




final getDefaultDisappearTimerUseCaseProvider =
Provider<GetDefaultDisappearTimerUseCase>((ref) {
  final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
    return FirebaseFirestore.instance;
  });
  final firestore = ref.read(firebaseFirestoreProvider); // يجب تعريفه مسبقاً
  final auth = FirebaseAuth.instance;

  final remote = AutoDisappearMassagesPrivacyRemoteDatasource(
    firestore: firestore,
  );

  final repository = AutoDisappearMassagesPrivacyRepositoryImpl(
    remoteDatasource: remote,
  );

  return GetDefaultDisappearTimerUseCase(
    repository: repository,
    auth: auth,
  );
});
