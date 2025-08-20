
import '../../../../domain/repository/account/delet account/delete_account_repository.dart';
import '../../../datasource/account/delet account/delet_account_remote_datasorce.dart';

class DeleteAccountRepositoryImpl implements DeleteAccountRepository {
  final DeleteAccountRemoteDataSource remoteDataSource;

  DeleteAccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> deleteAccount(String uid) async {
    await remoteDataSource.deleteAccount(uid);
  }
}
