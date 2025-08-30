import '../../../entities/privacy/links/links_privacy_entity.dart';

abstract class LinksPrivacyRepository {
  Future<LinksPrivacyEntity?> getLinksPrivacy(String uid);
  Future<void> setLinksPrivacy(String uid, LinksPrivacyEntity entity);
}
