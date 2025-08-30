abstract class AutoDisappearMassagesPrivacyRepository {
  Future<String?> getDefaultDisappearTimer(String uid);
  Future<void> setDefaultDisappearTimer(String uid, String timer);
}
