import '../../../entities/privacy/calls/privacy_calls_entity.dart';

abstract class PrivacyCallsRepository {
  Future<PrivacyCallsEntity> getPrivacyCalls(String uid);
  Future<void> updatePrivacyCalls(bool silence, String uid);
}
