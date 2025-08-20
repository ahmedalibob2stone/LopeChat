import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/enums/enum_massage.dart';
import '../../../../constant.dart';
import 'VideoPlayer.dart';

class DisplayTypeofMassage extends StatelessWidget {
  const DisplayTypeofMassage({Key? key, required this.message, required this.type}) : super(key: key);

  final String message;
  final EnumData type;

  @override
  Widget build(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();
    bool isPlaying = false;

    switch (type) {
      case EnumData.text:
        return Flexible(
          child: _buildRichText(message),
        );

      case EnumData.video:
        return Container(
          width: MediaQuery.of(context).size.width * 0.66,
          height: MediaQuery.of(context).size.height * 0.35,
          child: CustomVideoPlayer(videoUrl: message),
        );

      case EnumData.audio:
        return StatefulBuilder(
          builder: (context, setState) {
            return IconButton(
              highlightColor: Colors.transparent,
              constraints: const BoxConstraints(
                maxHeight: 30,
                minWidth: 175,
              ),
              onPressed: () async {
                if (isPlaying) {
                  await audioPlayer.pause();
                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  await audioPlayer.play(UrlSource(message));
                  setState(() {
                    isPlaying = true;
                  });
                }
              },
              icon: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle,
                size: 30,
                color: Colors.grey,
              ),
            );
          },
        );

      case EnumData.gif:
        return CachedNetworkImage(
          imageUrl: message,
        );

      default:
        return Container(
          width: MediaQuery.of(context).size.width * 0.66,
          height: MediaQuery.of(context).size.height * 0.35,
          child: CachedNetworkImage(
            imageUrl: message,
            fit: BoxFit.cover,
          ),
        );
    }
  }

  RichText _buildRichText(String text) {
    final linkRegex = RegExp(
      r'((https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\/\S*)?)',
      caseSensitive: false,
    );

    List<InlineSpan> children = [];
    int start = 0;

    for (final match in linkRegex.allMatches(text)) {
      if (match.start > start) {
        children.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: const TextStyle(color: kkkPrimaryColor, fontSize: 15),
          ),
        );
      }

      final url = text.substring(match.start, match.end);
      children.add(
        TextSpan(
          text: url,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontSize: 15,
          ),
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

    if (start < text.length) {
      children.add(
        TextSpan(
          text: text.substring(start),
          style: const TextStyle(color: kkkPrimaryColor, fontSize: 15),
        ),
      );
    }

    return RichText(
      text: TextSpan(children: children),
    );
  }
}
