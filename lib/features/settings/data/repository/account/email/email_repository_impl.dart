import '../../../../domain/repository/account/email/email_repository.dart';
import '../../../datasource/account/email/email_local_datasorce.dart';

class EmailRepositoryImpl implements EmailRepository {
  final EmailLocalDataSource localDataSource;

  EmailRepositoryImpl({required this.localDataSource});

  @override
  Future<String?> getEmail() {
    return localDataSource.getEmail();
  }

  @override
  Future<void> setEmail(String email) {
    return localDataSource.setEmail(email);
  }

  @override
  Future<void> clearEmail() {
    return localDataSource.clearEmail();
  }
}
