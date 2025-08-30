abstract class TwoStepVerificationRepository {
  Future<bool> isTwoStepEnabled();
  Future<void> setTwoStepEnabled(bool enabled);

  Future<String?> getPin();
  Future<void> setPin(String pin);

  Future<String?> getRecoveryEmail();
  Future<void> setRecoveryEmail(String email);

  Future<void> clearTwoStepVerificationData();
}
