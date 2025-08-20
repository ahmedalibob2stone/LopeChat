import '../../../repository/account/email/email_repository.dart';

class SetEmailUseCase {
  final EmailRepository repository;

  SetEmailUseCase(this.repository);

  Future<void> call(String email) async {
    await repository.setEmail(email);
  }
}