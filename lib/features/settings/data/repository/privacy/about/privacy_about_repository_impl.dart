


import '../../../../domain/entities/privacy/about/privacy_about_entity.dart';
import '../../../../domain/repository/privacy/about/privacy_about_repository.dart';
import '../../../datasource/privacy/about/privacy_about_remote_datasource.dart';
import '../../../model/privacy/bout/privacy_about_model.dart';

class PrivacyAboutRepositoryImpl implements PrivacyAboutRepository {
  final PrivacyAboutRemoteDatasourceImpl remoteDatasource;

  PrivacyAboutRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> updatePrivacyAbout(PrivacyAboutEntity entity) {
    final model = PrivacyAboutModel.fromEntity(entity);
    return remoteDatasource.updatePrivacyAbout(model);
  }

  @override
  Future<PrivacyAboutModel> getPrivacyAbout() {
    return remoteDatasource.getPrivacyAbout();
  }
}
