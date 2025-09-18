import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/enums/enum_massage.dart';
import '../../../../constant.dart';
import '../screan/chat_list.dart';
import '../screan/full_screan_image_screan.dart';
import 'VideoPlayer.dart';

class DisplayTypeofMassage extends StatefulWidget {
  const DisplayTypeofMassage({Key? key, required this.message, required this.type}) : super(key: key);

  final String message;
  final EnumData type;

  @override
  State<DisplayTypeofMassage> createState() => _DisplayTypeofMassageState();
}

class _DisplayTypeofMassageState extends State<DisplayTypeofMassage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = false; // عند الانتهاء تعود الأيقونة إلى pause_circle
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    switch (widget.type) {
      case EnumData.text:
        return Flexible(
          child: _buildRichText(widget.message),
        );

      case EnumData.video:
        return GestureDetector(
          onTap: () {
            final allMedia = (context.findAncestorStateOfType<ChatListState>())
                ?.getAllMedia() ??
                [widget.message];

            final currentIndex = allMedia.indexOf(widget.message);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullscreenImageGallery(
                  media: allMedia,
                  initialIndex: currentIndex,
                ),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CustomVideoPlayer(videoUrl: widget.message),
              ),
            ),
          ),
        );


      case EnumData.audio:
        return Container(
          width: MediaQuery.of(context).size.width * 0.55, // العرض (نسبة من الشاشة)
          height: 65, // الارتفاع ثابت مثل واتساب
          decoration: BoxDecoration(
            color: Colors.black12, // خلفية خفيفة
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: IconButton(
              iconSize: 36,
              icon: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: Colors.grey.shade700,
              ),
              onPressed: () async {
                if (isPlaying) {
                  await _audioPlayer.pause();
                  setState(() => isPlaying = false);
                } else {
                  await _audioPlayer.play(UrlSource(widget.message));
                  setState(() => isPlaying = true);
                }
              },
            ),
          ),
        );



      case EnumData.gif:
        return Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.66,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: widget.message,
              fit: BoxFit.cover,
            ),
          ),
        );


      default:
        return GestureDetector(
          onTap: () {
            final allImages = (context.findAncestorStateOfType<ChatListState>())
                ?.getAllMedia() ??
                [widget.message];

            final currentIndex = allImages.indexOf(widget.message);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullscreenImageGallery(
                  initialIndex: currentIndex, media: allImages,
                ),
              ),
            );
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.66,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.message,
                fit: BoxFit.cover,
              ),
            ),
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
