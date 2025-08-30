




import '../ datasources/api_datasorce.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthApiDataSource apiDataSource;

  AuthRepositoryImpl(this.apiDataSource, );

  @override
  Future<bool> sendOtp(String phoneNumber) {
    return apiDataSource.sendOtp(phoneNumber);
  }

  @override
  Future<String?> verifyOtp(String phoneNumber, String otp) {
    return apiDataSource.verifyOtp(phoneNumber, otp);
  }

  @override
  String? getCurrentUserId() {

    return null;
  }
}
