import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthApiDataSource {
  final String baseUrl;

  AuthApiDataSource(this.baseUrl);

  Future<bool> sendOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('https://lopechat.onrender.com/auth/send-otp'),

      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber}),

    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      // إرجاع رسالة الخطأ من السيرفر أو رسالة عامة
      throw Exception(data['error'] ?? 'Failed to send OTP');
    }
  }

  Future<String?> verifyOtp(String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse('https://lopechat.onrender.com/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    }
    return null;
  }
}


