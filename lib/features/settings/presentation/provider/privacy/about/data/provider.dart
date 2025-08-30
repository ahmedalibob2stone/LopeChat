import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/datasource/privacy/about/privacy_about_remote_datasource.dart';
import '../../../../../data/repository/privacy/about/privacy_about_repository_impl.dart';
import '../../../../../domain/repository/privacy/about/privacy_about_repository.dart';

final privacyAboutRemoteDatasourceProvider = Provider<PrivacyAboutRemoteDatasourceImpl>((ref) {
  return PrivacyAboutRemoteDatasourceImpl(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});
final privacyAboutRepositoryProvider = Provider<PrivacyAboutRepository>((ref) {
  final remoteDatasource = ref.watch(privacyAboutRemoteDatasourceProvider);
  return PrivacyAboutRepositoryImpl(remoteDatasource);
});
