
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../../main.dart';
import '../../../../../data/datasource/privacy/links/links_privacy_local_datasource.dart';
import '../../../../../data/datasource/privacy/links/links_privacy_remote_datasource.dart';
import '../../../../../data/repository/privacy/links/links_privacy_repository_impl.dart';
import '../../../../../domain/repository/privacy/links/links_privacy_repository.dart';




final linksPrivacyRemoteDataSourceProvider = Provider<LinksPrivacyRemoteDataSource>((ref) {
  return LinksPrivacyRemoteDataSourceImpl(FirebaseFirestore.instance);
});

final linksPrivacyLocalDataSourceProvider = Provider<LinksPrivacyLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LinksPrivacyLocalDataSourceImpl(prefs);
});

final linksPrivacyRepositoryProvider = Provider<LinksPrivacyRepository>((ref) {
  final remote = ref.watch(linksPrivacyRemoteDataSourceProvider);
  final local = ref.watch(linksPrivacyLocalDataSourceProvider);
  return LinksPrivacyRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
});
