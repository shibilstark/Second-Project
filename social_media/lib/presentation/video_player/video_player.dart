import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/core/constants/constants.dart';
import 'package:social_media/presentation/widgets/common_appbar.dart';
import 'package:social_media/presentation/widgets/gap.dart';
import 'package:video_player/video_player.dart';

class OnlineVideoPlayer extends StatefulWidget {
  OnlineVideoPlayer({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  State<OnlineVideoPlayer> createState() => _OnlineVideoPlayerState();
}

class _OnlineVideoPlayerState extends State<OnlineVideoPlayer> {
  late VideoPlayerController onlineVideoPlayerController;
  @override
  void initState() {
    onlineVideoPlayerController = VideoPlayerController.network(widget.path,
        videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: false, mixWithOthers: false))
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize().then((value) => onlineVideoPlayerController.play());
    super.initState();
  }

  _getPosition() {
    final duration = Duration(
        milliseconds:
            onlineVideoPlayerController.value.position.inMilliseconds.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, "0"))
        .join(":");
  }

  @override
  void dispose() {
    onlineVideoPlayerController.dispose();
    log("VideoDisposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: commonWhite,
        backgroundColor: commonBlack,
      ),
      // appBar: PreferredSize(
      //   child: CommonAppBar(title: ""),
      //   preferredSize: appBarHeight,
      // ),
      backgroundColor: themeBlack,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: SizedBox(
              child: AspectRatio(
                  aspectRatio: onlineVideoPlayerController.value.aspectRatio,
                  child: VideoPlayer(onlineVideoPlayerController)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.sm, vertical: 10.sm),
            child: Row(
              children: [
                Text(
                  _getPosition(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: pureWhite, fontSize: 12.sm),
                ),
                Gap(
                  W: 5.sm,
                ),
                Expanded(
                  child: VideoProgressIndicator(
                    onlineVideoPlayerController,
                    allowScrubbing: true,
                    padding: EdgeInsets.all(3),
                    colors: const VideoProgressColors(
                        // playedColor: primaryBlue,
                        // bufferedColor: pureWhite,
                        // backgroundColor: smoothWhite,
                        ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (onlineVideoPlayerController.value.isPlaying) {
                          onlineVideoPlayerController.pause();
                        } else {
                          onlineVideoPlayerController.play();
                        }
                      });
                    },
                    icon: Icon(
                      onlineVideoPlayerController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: pureWhite,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
