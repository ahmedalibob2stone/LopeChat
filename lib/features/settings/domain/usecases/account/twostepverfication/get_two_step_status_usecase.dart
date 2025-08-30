
import '../../../repository/account/two step verification/two_step_verification_repository.dart';

class GetTwoStepStatusUseCase {
  final TwoStepVerificationRepository _repository;

  GetTwoStepStatusUseCase(this._repository);
  Future<bool> call() async {
    return await _repository.isTwoStepEnabled();
  }

}