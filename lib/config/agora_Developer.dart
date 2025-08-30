import 'package:flutter_dotenv/flutter_dotenv.dart';


class AgoragConfig{
  static String token='';
  static String appId=dotenv.env['AGORA_APP_ID']!;
  static String appcertificate=dotenv.env['AGORA_APP_CERTIFICATE']!;

}