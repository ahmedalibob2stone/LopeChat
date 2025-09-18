import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/VideoPlayer.dart';

class FullscreenImageGallery extends StatefulWidget {
  final List<String> media; // روابط الصور + الفيديوهات
  final int initialIndex;

  const FullscreenImageGallery({
    Key? key,
    required this.media,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<FullscreenImageGallery> createState() => _FullscreenImageGalleryState();
}

class _FullscreenImageGalleryState extends State<FullscreenImageGallery> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isVideo(String url) {
    return url.endsWith(".mp4") || url.endsWith(".mov") || url.endsWith(".avi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "${currentIndex + 1} / ${widget.media.length}",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.media.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final url = widget.media[index];
          if (_isVideo(url)) {
            return Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CustomVideoPlayer(videoUrl: url),
              ),
            );
          } else {
            return InteractiveViewer(
              maxScale: 5,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: url,
                  placeholder: (context, url) =>
                  const CircularProgressIndicator(color: Colors.white),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.red),
                  fit: BoxFit.contain,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
