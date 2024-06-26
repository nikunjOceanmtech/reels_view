import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    cameraController = CameraController(cameras.first, ResolutionPreset.max);
    await cameraController?.initialize();
    emit(CameraLoadedState(isVideoRecoding: false));
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

  void nextButton({required BuildContext context}) {
    print("===========${videoFile?.path}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShortsEditorScreen(videoPath: videoFile?.path ?? ""),
      ),
    );
  }
}
