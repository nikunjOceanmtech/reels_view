import 'package:flutter/material.dart';
import 'package:reels_view/di/get_it.dart';
import 'package:reels_view/screens/video_player/cubit/video_player_cubit.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerCubit videoPlayerCubit;

  @override
  void initState() {
    videoPlayerCubit = getItInstance<VideoPlayerCubit>();
    videoPlayerCubit.loadVideo();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: 1 != 1
            ? FutureBuilder(
                future: videoPlayerCubit.video1(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return InkWell(
                      onTap: () {},
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: snapshot.data!.value.aspectRatio,
                          child: VideoPlayer(snapshot.data!),
                        ),
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                },
              )
            : videoPlayerCubit.controller != null
                ? Column(
                    children: [
                      InkWell(
                        onTap: () {
                          videoPlayerCubit.playOrPauseVideo();
                        },
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: videoPlayerCubit.controller!.value.aspectRatio,
                            child: VideoPlayer(videoPlayerCubit.controller!),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
      ),
    );
  }
}
