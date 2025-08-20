import 'dart:ui';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkTextSpanBuilder extends SpecialTextSpanBuilder {
  @override
  SpecialText? createSpecialText(
      String flag,
      {TextStyle? textStyle,
        onTap,
        required int index}) {

    return null;
  }

  @override
  TextSpan build(String data, {TextStyle? textStyle, onTap}) {
    final RegExp linkRegex = RegExp(
      r'((https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\/\S*)?)',
      caseSensitive: false,
    );

    List<InlineSpan> children = [];
    int start = 0;

    for (final match in linkRegex.allMatches(data)) {
      if (match.start > start) {
        children.add(TextSpan(text: data.substring(start, match.start), style: textStyle));
      }
      final url = data.substring(match.start, match.end);
      children.add(
        TextSpan(
          text: url,
          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
        ),
      );
      start = match.end;
    }

    if (start < data.length) {
      children.add(TextSpan(text: data.substring(start), style: textStyle));
    }

    return TextSpan(children: children);
  }
}
