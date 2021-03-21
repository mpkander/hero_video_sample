import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hero_streaming/screens/detail.dart';
import 'package:hero_streaming/widgets.dart';

const List<VideoItem> _data = [
  VideoItem(
    id: '1',
    title: 'Мафиозник',
    imageProvider: AssetImage('assets/mafioznik_preview.png'),
    video: 'assets/mafioznik.mp4',
  ),
  VideoItem(
    id: '2',
    title: 'Oblivion NPC dialogue',
    imageProvider: AssetImage('assets/oblivion_preview.png'),
    video: 'assets/oblivion.mp4',
  ),
  VideoItem(
    id: '3',
    title: 'Нажарив окорочок',
    imageProvider: AssetImage('assets/okorochok_preview.png'),
    video: 'assets/okorochok.mp4',
  ),
  VideoItem(
    id: '4',
    title: 'Борщ с капусткой',
    imageProvider: AssetImage('assets/litvinkov_preview.png'),
    video: 'assets/litvinkov.mp4',
  ),
];

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    log(DefaultTextStyle.of(context).style.fontFamily.toString());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: mediaQuery.padding.top),
              const SizedBox(height: 70),
              Text(
                'Приколы',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              ..._data
                  .expand((e) => [
                        Hero(
                          tag: e.id,
                          transitionOnUserGestures: true,
                          child: SizedBox(
                            height: 340,
                            child: VideoCard(
                              item: e,
                              animation: AlwaysStoppedAnimation(0),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  DetailScreen.createRoute(item: e),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ])
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoItem {
  final String id;

  final ImageProvider imageProvider;

  final String video;

  final String title;

  const VideoItem({
    required this.id,
    required this.imageProvider,
    required this.video,
    required this.title,
  });
}
