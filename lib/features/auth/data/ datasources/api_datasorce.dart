import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/verify_otp_response_model.dart';

class AuthApiDataSource {
  final String baseUrl;

  AuthApiDataSource( {required this.baseUrl});

  Future<bool> sendOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-otp'),

      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber}),

    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Failed to send OTP');
    }
  }

  Future<VerifyOtpResponse?> verifyOtp(String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return VerifyOtpResponse.fromJson(data);
    } else {
      return null;
    }
  }
}


