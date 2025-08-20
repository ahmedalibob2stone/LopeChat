
import '../../../../domain/entities/privacy/calls/privacy_calls_entity.dart';
import '../../../../domain/repository/privacy/calls/privacy_calls_repository.dart';
import '../../../datasource/privacy/calls/privacy_calls_remote_datasource.dart';

class PrivacyCallsRepositoryImpl implements PrivacyCallsRepository {
  final PrivacyCallsRemoteDatasource remoteDatasource;

  PrivacyCallsRepositoryImpl({required this.remoteDatasource});

  @override
  Future<PrivacyCallsEntity> getPrivacyCalls(String uid) async {
    return await remoteDatasource.getPrivacyCalls(uid);
  }

  @override
  Future<void> updatePrivacyCalls(bool silence, String uid) async {
    await remoteDatasource.updatePrivacyCalls(silence, uid);
  }
}
