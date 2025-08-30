

import '../../../../data/model/privacy/bout/privacy_about_model.dart';
import '../../../entities/privacy/about/privacy_about_entity.dart';

abstract class PrivacyAboutRepository {
  Future<void> updatePrivacyAbout(PrivacyAboutEntity model);
  Future<PrivacyAboutModel> getPrivacyAbout();
}
