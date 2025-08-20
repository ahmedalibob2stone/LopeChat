import '../../../../domain/entities/privacy/links/links_privacy_entity.dart';
import '../../../../domain/repository/privacy/links/links_privacy_repository.dart';
import '../../../datasource/privacy/links/links_privacy_remote_datasource.dart';
import '../../../datasource/privacy/links/links_privacy_local_datasource.dart';
import '../../../model/privacy/links/model/links_privacy_model.dart';

class LinksPrivacyRepositoryImpl implements LinksPrivacyRepository {
  final LinksPrivacyRemoteDataSource remoteDataSource;
  final LinksPrivacyLocalDataSource localDataSource;

  LinksPrivacyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<LinksPrivacyEntity?> getLinksPrivacy(String uid) async {
    try {
      final model = await remoteDataSource.getLinksPrivacy(uid);
      if (model != null) {
        await localDataSource.cacheLinksPrivacy(model);
      }
      return model;
    } catch (e) {
      // في حال فشل الاتصال، نحاول قراءة القيمة من الكاش
      final cachedModel = await localDataSource.getCachedLinksPrivacy();
      return cachedModel;
    }
  }

  @override
  Future<void> setLinksPrivacy(String uid, LinksPrivacyEntity entity) async {
    final model = LinksPrivacyModel.fromEntity(entity);
    await remoteDataSource.setLinksPrivacy(uid, model);
    await localDataSource.cacheLinksPrivacy(model); // تحديث الكاش بعد الحفظ
  }
}
