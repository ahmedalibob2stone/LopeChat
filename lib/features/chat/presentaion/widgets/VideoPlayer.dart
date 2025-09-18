import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.setVolume(1);
      });

    _videoPlayerController.addListener(() {
      final bool isPlaying = _videoPlayerController.value.isPlaying;
      if (isPlaying != _isPlaying) {
        setState(() => _isPlaying = isPlaying);
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoPlayerController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        VideoPlayer(_videoPlayerController),

        // زر التشغيل/الإيقاف
        GestureDetector(
          onTap: _togglePlayPause,
          child: AnimatedOpacity(
            opacity: _isPlaying ? 0 : 1, // يخفي الأيقونة أثناء التشغيل
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.play_circle_fill,
              size: 60,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}
