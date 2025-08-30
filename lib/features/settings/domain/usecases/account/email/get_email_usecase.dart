
import '../../../repository/account/email/email_repository.dart';

class GetEmailUseCase {
  final EmailRepository repository;

  GetEmailUseCase(this.repository);

  Future<String?> call() async {
    return await repository.getEmail();
  }
}




