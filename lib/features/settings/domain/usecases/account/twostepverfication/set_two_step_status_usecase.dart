
import '../../../repository/account/two step verification/two_step_verification_repository.dart';

class SetTwoStepStatusUseCase {
  final TwoStepVerificationRepository _repository;

  SetTwoStepStatusUseCase(this._repository);

  Future<void> call(bool enabled) async {
    await _repository.setTwoStepEnabled(enabled);
  }
}