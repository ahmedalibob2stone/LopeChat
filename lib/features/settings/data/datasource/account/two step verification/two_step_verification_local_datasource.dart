import 'package:shared_preferences/shared_preferences.dart';

abstract class TwoStepVerificationLocalDataSource {
  Future<bool> getIsTwoStepEnabled();
  Future<void> setIsTwoStepEnabled(bool enabled);

  Future<String?> getPin();
  Future<void> setPin(String pin);

  Future<String?> getRecoveryEmail();
  Future<void> setRecoveryEmail(String email);

  Future<void> clearTwoStepVerificationData();
}

class TwoStepVerificationLocalDataSourceImpl implements TwoStepVerificationLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const _keyIsTwoStepEnabled = 'two_step_enabled';
  static const _keyPin = 'two_step_pin';
  static const _keyRecoveryEmail = 'two_step_recovery_email';

  TwoStepVerificationLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> getIsTwoStepEnabled() async {
    return sharedPreferences.getBool(_keyIsTwoStepEnabled) ?? false;
  }

  @override
  Future<void> setIsTwoStepEnabled(bool enabled) async {
    await sharedPreferences.setBool(_keyIsTwoStepEnabled, enabled);
  }

  @override
  Future<String?> getPin() async {
    return sharedPreferences.getString(_keyPin);
  }

  @override
  Future<void> setPin(String pin) async {
    await sharedPreferences.setString(_keyPin, pin);
  }

  @override
  Future<String?> getRecoveryEmail() async {
    return sharedPreferences.getString(_keyRecoveryEmail);
  }

  @override
  Future<void> setRecoveryEmail(String email) async {
    await sharedPreferences.setString(_keyRecoveryEmail, email);
  }

  @override
  Future<void> clearTwoStepVerificationData() async {
    await sharedPreferences.remove(_keyIsTwoStepEnabled);
    await sharedPreferences.remove(_keyPin);
    await sharedPreferences.remove(_keyRecoveryEmail);
  }
}
