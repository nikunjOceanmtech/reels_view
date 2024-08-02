import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final File videoFile1;
  final File videoFile2;

  const VideoView({super.key, required this.videoFile1, required this.videoFile2});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController controller1;
  late VideoPlayerController controller2;
  bool isInitialized = false;

  @override
  void initState() {
    laodVideo1();
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  Future<void> laodVideo1() async {
    controller1 = VideoPlayerController.file(widget.videoFile1);
    await controller1.initialize().then(
          (value) async => await controller1.setLooping(true).then(
                (value) async => await controller1.play().then((value) => laodVideo2()),
              ),
        );
  }

  Future<void> laodVideo2() async {
    controller2 = VideoPlayerController.file(widget.videoFile2);
    await controller2.initialize().then(
          (value) async => await controller2.play().then(
                (value) async =>
                    await controller2.setLooping(true).then((value) => setState(() => isInitialized = true)),
              ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isInitialized
          ? Stack(
              children: [
                Row(
                  children: [
                    SizedBox(width: ScreenUtil().screenWidth / 2, child: VideoPlayer(controller1)),
                    Container(width: ScreenUtil().screenWidth / 2, color: Colors.transparent),
                  ],
                ),
                Row(
                  children: [
                    Container(width: ScreenUtil().screenWidth / 2, color: Colors.transparent),
                    SizedBox(width: ScreenUtil().screenWidth / 2, child: VideoPlayer(controller2)),
                  ],
                ),
              ],
            )
          : CircularProgressIndicator(),
    );
  }
}
