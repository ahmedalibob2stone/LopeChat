
import '../../../model/privacy/calls/privacy_calls_model.dart';
abstract class PrivacyCallsRemoteDatasource{
  Future<PrivacyCallsModel> getPrivacyCalls(String uid) ;
  Future<void> updatePrivacyCalls(bool silence,String uid);
}
