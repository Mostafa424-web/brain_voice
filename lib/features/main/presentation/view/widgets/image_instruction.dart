import 'dart:async';

import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final String imageProvider;

  ImageViewer({required this.imageProvider});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Image.asset(widget.imageProvider),
    );
  }
}