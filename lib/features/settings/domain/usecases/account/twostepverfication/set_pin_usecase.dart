import '../../../repository/account/two step verification/two_step_verification_repository.dart';

class SetPinUseCase {
  final TwoStepVerificationRepository _repository;

  SetPinUseCase(this._repository);

  Future<void> call(String pin) async {
    await _repository.setPin(pin);
  }
}