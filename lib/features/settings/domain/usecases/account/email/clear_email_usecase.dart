import '../../../repository/account/email/email_repository.dart';

class ClearEmailUseCase {
  final EmailRepository repository;

  ClearEmailUseCase(this.repository);

  Future<void> call() async {
    await repository.clearEmail();
  }
}