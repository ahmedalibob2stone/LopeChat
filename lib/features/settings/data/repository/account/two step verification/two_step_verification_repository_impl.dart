

import '../../../datasource/account/two step verification/two_step_verification_local_datasource.dart';
import '../../../../domain/repository/account/two step verification/two_step_verification_repository.dart';

class TwoStepVerificationRepositoryImpl implements TwoStepVerificationRepository {
  final TwoStepVerificationLocalDataSource localDataSource;

  TwoStepVerificationRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> isTwoStepEnabled() {
    return localDataSource.getIsTwoStepEnabled();
  }

  @override
  Future<void> setTwoStepEnabled(bool enabled) {
    return localDataSource.setIsTwoStepEnabled(enabled);
  }

  @override
  Future<String?> getPin() {
    return localDataSource.getPin();
  }

  @override
  Future<void> setPin(String pin) {
    return localDataSource.setPin(pin);
  }

  @override
  Future<String?> getRecoveryEmail() {
    return localDataSource.getRecoveryEmail();
  }

  @override
  Future<void> setRecoveryEmail(String email) {
    return localDataSource.setRecoveryEmail(email);
  }

  @override
  Future<void> clearTwoStepVerificationData() {
    return localDataSource.clearTwoStepVerificationData();
  }
}
