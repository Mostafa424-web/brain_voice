import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 2), (){
    //   _controller = VideoPlayerController.asset(widget.videoUrl,)
    //     ..initialize().then((_) {
    //       setState(() {});
    //     });
    // });
    _controller = VideoPlayerController.asset(widget.videoUrl,)
      ..initialize().then((_) {
              setState(() {});
            });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio * 0.33,
      child: Stack(
        children: [
          VideoPlayer(_controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_isPlaying) {
                    _controller!.pause();
                    _isPlaying = false;
                  } else {
                    _controller!.play();
                    _isPlaying = true;
                  }
                });
              },
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}