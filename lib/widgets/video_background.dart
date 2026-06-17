import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TextileVideoBackground extends StatefulWidget {
  final Widget child;
  final String videoPath;
  final double opacity;

  const TextileVideoBackground({
    super.key,
    required this.child,
    this.videoPath = "lib/assets/videos/textile_bg.mp4",
    this.opacity = 0.55,
  });

  @override
  State<TextileVideoBackground> createState() => _TextileVideoBackgroundState();
}

class _TextileVideoBackgroundState extends State<TextileVideoBackground> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    final isNetwork =
        widget.videoPath.startsWith("http://") ||
        widget.videoPath.startsWith("https://");

    _controller = isNetwork
        ? VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
        : VideoPlayerController.asset(widget.videoPath);

    _controller
        .initialize()
        .then((_) {
          if (!mounted) return;

          _controller
            ..setLooping(true)
            ..setVolume(0.0)
            ..play();

          setState(() {
            _isInitialized = true;
          });
        })
        .catchError((error) {
          debugPrint("Video initialization error: $error");
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
              : Container(
                  color: const Color(0xFF1B3D38),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white30),
                  ),
                ),
        ),

        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: widget.opacity),
          ),
        ),

        widget.child,
      ],
    );
  }
}
