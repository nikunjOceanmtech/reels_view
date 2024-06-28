import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reels_view/screens/shorts_editor/view/shorts_editor_screen.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitialState());

  CameraController? cameraController;

  XFile? videoFile;

  Future<void> loadCamera() async {
    cameraController?.dispose();
    cameraController = null;

    List<CameraDescription> cameras = await availableCameras();
    List<CameraDescription> calerasList =
        cameras.where((element) => element.lensDirection == CameraLensDirection.back).toList();
    if (calerasList.isNotEmpty) {
      cameraController = CameraController(calerasList.first, ResolutionPreset.veryHigh);
      await cameraController?.initialize();
      emit(CameraLoadedState(isVideoRecoding: false));
    }
  }

  Future<void> disposeCamera() async {
    await cameraController?.dispose();
    cameraController = null;
  }

  Future<void> startVideoRecode({required CameraLoadedState state}) async {
    try {
      await cameraController?.startVideoRecording();
      emit(state.copyWith(isVideoRecoding: true, random: Random().nextDouble()));
    } catch (e) {
      print("======= startVideoRecode -> $e");
      emit(CameraErrorState());
    }
  }

  Future<void> stopVideoRecode({required CameraLoadedState state}) async {
    try {
      videoFile = await cameraController?.stopVideoRecording();
      emit(state.copyWith(isVideoRecoding: false, random: Random().nextDouble()));
    } catch (e) {
      print("======= StopVideoRecode -> $e");
      emit(CameraErrorState());
    }
  }

  Future<void> nextButton({required BuildContext context}) async {
    print("=========+${await getFileSize(videoFile?.path ?? "", 2)}");
    double size = await getFileSize(videoFile?.path ?? "", 2);
    // if (size < 5) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => ShortsEditorScreen(videoPath: videoFile?.path ?? "")),
    //   );
    //   return;
    // }
    print("==========Start -> ${DateTime.now()}");
    String outputVideoPath = await setFileInDevice('video_size_compress_${DateTime.now().microsecondsSinceEpoch}.mp4');
    String command = "-i ${videoFile?.path} -vcodec libx264 -preset ultrafast -crf 23 $outputVideoPath";
    FFmpegSession session = await FFmpegKit.execute(command);
    if ((await session.getReturnCode())?.getValue() == ReturnCode.success) {
      print("==========Success -> ${DateTime.now()}");
      session.cancel();
      print("=========+${await getFileSize(outputVideoPath, 2)}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShortsEditorScreen(videoPath: outputVideoPath)),
      );
    } else {
      for (var log in await session.getAllLogs()) {
        print("========${log.getMessage()}");
      }
      session.cancel();
    }
  }

  Future<double> getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return 0;
    // const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return (bytes / pow(1024, i));
  }

  Future<String> setFileInDevice(String fileName) async {
    final directory = await commonDirectoryGet();
    return '$directory/$fileName';
  }

  Future<String> commonDirectoryGet() async {
    final directory = await getTemporaryDirectory();
    final Directory directoryFolder = Directory('${directory.path}/shortsVideo/');
    if (await directoryFolder.exists()) {
      return '${directory.path}/shortsVideo';
    } else {
      await directoryFolder.create(recursive: true);
      return '${directory.path}/shortsVideo';
    }
  }
}
