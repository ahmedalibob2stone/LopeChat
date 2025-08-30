import '../../../entities/privacy/about/privacy_about_entity.dart';
import '../../../repository/privacy/about/privacy_about_repository.dart';

class GetAboutPrivacyUseCase {
  final PrivacyAboutRepository repository;

  GetAboutPrivacyUseCase(this.repository);

  Future<PrivacyAboutEntity> call() {
    return repository.getPrivacyAbout();
  }
}
