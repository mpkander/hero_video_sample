import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hero_streaming/screens/list.dart';
import 'package:hero_streaming/widgets.dart';

class DetailScreen extends StatefulWidget {
  final VideoItem item;

  const DetailScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();

  static Route createRoute({required VideoItem item}) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 400),
      reverseTransitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => DetailScreen(
        item: item,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.decelerate)),
          child: child,
        );
      },
    );
  }
}

class _DetailScreenState extends State<DetailScreen> {
  Widget _buildButton() => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white.withOpacity(.4),
            child: Container(
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Hero(
              tag: widget.item.id,
              transitionOnUserGestures: true,
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                  fromHeroContext, toHeroContext) {
                return VideoCard(
                  item: widget.item,
                  animation: animation,
                );
              },
              child: VideoCard(
                item: widget.item,
                animation: AlwaysStoppedAnimation(1),
                playVideo: true,
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Padding(
          //     padding: EdgeInsets.only(bottom: 50 + mediaQuery.padding.bottom),
          //     child: FractionallySizedBox(
          //       widthFactor: .4,
          //       child: _buildButton(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
