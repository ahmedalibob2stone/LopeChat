


// clear_two_step_verification_usecase.dart
import '../../../repository/account/two step verification/two_step_verification_repository.dart';

class ClearTwoStepVerificationUseCase {
  final TwoStepVerificationRepository _repository;

  ClearTwoStepVerificationUseCase(this._repository);

  Future<void> call() async {
    await _repository.clearTwoStepVerificationData();
  }
}
