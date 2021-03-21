import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hero_streaming/screens/list.dart';
import 'package:video_player/video_player.dart';

class VideoCard extends StatefulWidget {
  final Function()? onPressed;

  final Animation<double> animation;

  final VideoItem item;

  final bool playVideo;

  const VideoCard({
    Key? key,
    this.onPressed,
    required this.animation,
    required this.item,
    this.playVideo = false,
  }) : super(key: key);

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    if (widget.playVideo) {
      _controller = VideoPlayerController.asset(
        widget.item.video,
      )
        ..setLooping(true)
        ..play();

      _initializeVideoPlayerFuture = _controller?.initialize();
    }
  }

  Widget _buildImage() => Image(
        image: widget.item.imageProvider,
        fit: BoxFit.cover,
      );

  Widget _buildVideo() => FutureBuilder<void>(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          log('Future: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.done) {
            return FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller?.value.size.width ?? 0,
                height: _controller?.value.size.height ?? 0,
                child: VideoPlayer(_controller!),
              ),
            );
          } else {
            return _buildImage();
          }
        },
      );

  Widget _buildTitle() => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white.withOpacity(.4),
            child: Text(
              widget.item.title,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) => ClipRRect(
        borderRadius: BorderRadius.all(
            Radius.circular((widget.animation.value - 1).abs() * 30)),
        child: GestureDetector(
          onVerticalDragEnd: widget.animation.value == 1
              ? (details) {
                  if (widget.animation.value != 1) return;

                  if (details.velocity.pixelsPerSecond.dy > 300) {
                    Navigator.pop(context);
                  }
                }
              : null,
          onTap: widget.onPressed,
          child: Material(
            color: Colors.white,
            child: Stack(
              children: [
                Positioned.fill(
                  child: widget.playVideo ? _buildVideo() : _buildImage(),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Opacity(
                    opacity: (widget.animation.value - 1).abs(),
                    child: _buildTitle(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
