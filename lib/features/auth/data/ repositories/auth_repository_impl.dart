




import '../ datasources/api_datasorce.dart';
import '../../domain/entities/verify_otp_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthApiDataSource apiDataSource;

  AuthRepositoryImpl(this.apiDataSource, );

  @override
  Future<bool> sendOtp(String phoneNumber) {
    return apiDataSource.sendOtp(phoneNumber);
  }

  @override
  Future<VerifyOtpEntity?> verifyOtp(String phoneNumber, String otp) async {
    final response = await apiDataSource.verifyOtp(phoneNumber, otp);
    if (response == null) return null;

    return VerifyOtpEntity(
      token: response.token,
      attempts: response.attempts,
    );
  }


  @override
  String? getCurrentUserId() {

    return null;
  }
}
