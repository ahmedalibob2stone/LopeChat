import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../enums/enum_massage.dart';

Widget messageBubble(String text, EnumData type) {
  if (type == EnumData.link) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(text);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // باقي أنواع الرسائل
  return Text(text);
}
