
import '../../../../domain/repository/privacy/auto disappear message/auto_disappear_messages_privacy_repository.dart';
import '../../../datasource/privacy/auto disappear message/auto_disappear_privacy_remote_datasorce.dart';

class AutoDisappearMassagesPrivacyRepositoryImpl
    implements AutoDisappearMassagesPrivacyRepository {
  final AutoDisappearMassagesPrivacyRemoteDatasource remoteDatasource;

  AutoDisappearMassagesPrivacyRepositoryImpl({required this.remoteDatasource});

  @override
  Future<String?> getDefaultDisappearTimer(String uid) async {
    final model = await remoteDatasource.getDefaultTimer(uid);
    return model?.timer;
  }

  @override
  Future<void> setDefaultDisappearTimer(String uid, String timer) async {
    await remoteDatasource.setDefaultTimer(uid, timer);
  }
}
