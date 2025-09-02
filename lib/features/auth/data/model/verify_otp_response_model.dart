// Data Layer
import '../../domain/entities/verify_otp_entity.dart';

class VerifyOtpResponse extends VerifyOtpEntity {
  VerifyOtpResponse({
    String? token,
    required int attempts,
  }) : super(token: token, attempts: attempts);

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      token: json['token'],
      attempts: json['attempts'] ?? 0,
    );
  }
  factory VerifyOtpResponse.fromEntity(VerifyOtpResponse entity) {
    return VerifyOtpResponse(
    token:entity.token,
    attempts: entity.attempts
    );

  }

}
