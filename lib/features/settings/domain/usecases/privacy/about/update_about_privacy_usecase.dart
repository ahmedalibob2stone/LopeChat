import '../../../entities/privacy/about/privacy_about_entity.dart';
import '../../../repository/privacy/about/privacy_about_repository.dart';

class UpdateAboutPrivacyUseCase {
  final PrivacyAboutRepository repository;

  UpdateAboutPrivacyUseCase(this.repository);

  Future<void> call(PrivacyAboutEntity entity) {
    return repository.updatePrivacyAbout(entity);
  }
}
