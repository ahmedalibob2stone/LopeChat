import '../../../repository/account/two step verification/two_step_verification_repository.dart';

class GetRecoveryEmailUseCase {
  final TwoStepVerificationRepository _repository;

  GetRecoveryEmailUseCase(this._repository);

  Future<String?> call() async {
    return await _repository.getRecoveryEmail();
  }
}