import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  // late VideoPlayerController controller;
  late BetterPlayerController betterPlayerController;
  bool isPlaying = false;

  @override
  void initState() {
    // controller = VideoPlayerController.network(widget.url)
    //   ..initialize().then((value) => controller.setVolume(1));

    betterPlayerController =
        BetterPlayerController(const BetterPlayerConfiguration(
      autoPlay: false,
      looping: true,
      fullScreenByDefault: false,
    ));

    betterPlayerController
        .setupDataSource(BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.url,
          cacheConfiguration: const BetterPlayerCacheConfiguration(
            useCache: true,
            preCacheSize: 10 * 1024 * 1024,
            maxCacheSize: 10 * 1024 * 1024,
            maxCacheFileSize: 10 * 1024 * 1024,
            key: "testCacheKey",
          ),
        ))
        .then((value) => betterPlayerController.setVolume(1));

    super.initState();
  }

  @override
  void dispose() {
    betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(controller: betterPlayerController),
    );
  }
}
