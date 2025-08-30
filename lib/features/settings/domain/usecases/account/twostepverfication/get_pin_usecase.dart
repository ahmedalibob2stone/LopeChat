import '../../../repository/account/two step verification/two_step_verification_repository.dart';

class GetPinUseCase {
  final TwoStepVerificationRepository _repository;

  GetPinUseCase(this._repository);

  Future<String?> call() async {
    return await _repository.getPin();
  }
}