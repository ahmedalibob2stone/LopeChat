import '../../../../domain/repository/privacy/advanced/advanced_privacy_repository.dart';
import '../../../datasource/privacy/advanced/advanced_privacy_datasource.dart';
import '../../../model/privacy/advanced/advanced_privacy_model.dart';



class AdvancedPrivacyRepositoryImpl implements AdvancedPrivacyRepository {
  final AdvancedPrivacyRemoteDataSource remoteDataSource;
  final AdvancedPrivacyLocalDatasource localDataSource;

  AdvancedPrivacyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // Firebase
  @override
  Future<void> setBlockUnknownSenders(String uid, bool value) {
    return remoteDataSource.setBlockUnknownSenders(uid: uid, value: value);
  }

  @override
  Future<AdvancedPrivacyModel> getBlockUnknownSenders(String uid) {
    return remoteDataSource.getBlockUnknownSenders(uid);
  }

  // SharedPreferences
  @override
  Future<void> setProtectIpInCalls(bool value) {
    return localDataSource.setProtectIpInCalls(value);
  }

  @override
  Future<bool> getProtectIpInCalls() {
    return localDataSource.getProtectIpInCalls();
  }

  @override
  Future<void> setDisableLinkPreviews(bool value) {
    return localDataSource.setDisableLinkPreviews(value);
  }

  @override
  Future<bool> getDisableLinkPreviews() {
    return localDataSource.getDisableLinkPreviews();
  }
}
