import '../../../repository/account/two step verification/two_step_verification_repository.dart';

class SetRecoveryEmailUseCase {
  final TwoStepVerificationRepository _repository;

  SetRecoveryEmailUseCase(this._repository);

  Future<void> call(String email) async {
    await _repository.setRecoveryEmail(email);
  }
}