import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../main.dart';
import '../../../../../data/datasource/privacy/advanced/advanced_privacy_datasource.dart';
import '../../../../../data/datasource/privacy/advanced/advanced_privacy_local_datasorce.dart';
import '../../../../../data/datasource/privacy/advanced/advanced_privacy_remote_datasource_impl.dart';
import '../../../../../data/repository/privacy/advanced/advanced_privacy_repository_impl.dart';
import '../../../../../domain/repository/privacy/advanced/advanced_privacy_repository.dart';
import '../../../../../domain/usecases/privacy/advanced/set_disable_link_previews_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';


final advancedPrivacyRemoteDataSourceProvider = Provider<AdvancedPrivacyRemoteDataSource>((ref) {
  return AdvancedPrivacyRemoteDataSourceImpl(firestore: FirebaseFirestore.instance); // إذا كان يحتاج مزودات أخرى، ضفها هنا
});

final advancedPrivacyLocalDataSourceProvider = Provider<AdvancedPrivacyLocalDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AdvancedPrivacyLocalDatasourceImpl( prefs);
});

final advancedPrivacyRepositoryProvider = Provider<AdvancedPrivacyRepository>((ref) {
  final remoteDataSource = ref.watch(advancedPrivacyRemoteDataSourceProvider);
  final localDataSource = ref.watch(advancedPrivacyLocalDataSourceProvider);

  return AdvancedPrivacyRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final setDisableLinkPreviewsUseCaseProvider = Provider<SetDisableLinkPreviewsUseCase>((ref) {
  return SetDisableLinkPreviewsUseCase(
    repository: ref.watch(advancedPrivacyRepositoryProvider),
  );
});
