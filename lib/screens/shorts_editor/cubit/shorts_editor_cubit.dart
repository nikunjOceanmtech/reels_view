import 'dart:io';
import 'dart:math';

import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reels_view/screens/shorts_editor/cubit/shorts_editor_state.dart';
import 'package:video_player/video_player.dart';

class ShortsEditorCubit extends Cubit<ShortsEditorState> {
  ShortsEditorCubit() : super(ShortsEditorInitialState());

  VideoPlayerController? videoPlayerController;

  String videoPath = "";

  Future<void> loadVideo({required String filePath}) async {
    videoPlayerController?.dispose();
    videoPlayerController = null;
    videoPath = filePath;
    videoPlayerController = VideoPlayerController.file(File(filePath));
    await videoPlayerController?.initialize().then(
          (value) => videoPlayerController!.play().then(
                (value) => videoPlayerController!.setLooping(true).then(
                  (value) {
                    emit(ShortsEditorLoadedState(filterPath: '', isFilterShow: false, isLoadingVideo: false));
                  },
                ),
              ),
        );
  }

  void onFilterChanged({required ShortsEditorLoadedState state, required String selectedPath}) {
    emit(state.copyWith(filterPath: selectedPath, random: Random().nextDouble()));
  }

  void showFilterView({required ShortsEditorLoadedState state, required bool isFilterShow}) {
    emit(state.copyWith(isFilterShow: isFilterShow, random: Random().nextDouble()));
  }

  Future<void> loadFilter({required ShortsEditorLoadedState state}) async {
    print("==========Start -> ${DateTime.now()}");
    emit(state.copyWith(isLoadingVideo: true));
    String filterImagePath = await getFilterImage(state: state);
    String outputVideoPath = await setFileInDevice('filter_${DateTime.now().microsecondsSinceEpoch}.mp4');

    List<String> args = [
      "-y",
      "-i",
      videoPath,
      "-i",
      filterImagePath,
      '-filter_complex',
      "[0:v][1:v] overlay=0:0",
      "-c:v",
      "libx264",
      '-preset',
      'superfast',
      // "-crf",
      // "23",
      // "-r",
      // "15",
      // '-c:a',
      // 'copy',
      outputVideoPath,
    ];

    FFmpegSession session = await FFmpegKit.executeWithArguments(args);

    if ((await session.getReturnCode())?.getValue() == ReturnCode.success) {
      print("==========Success -> ${DateTime.now()}");
      videoPath = outputVideoPath;
      session.cancel();
      await loadVideo(filePath: outputVideoPath);
    } else {
      for (var log in await session.getAllLogs()) {
        print("========${log.getMessage()}");
      }
      emit(state.copyWith(isLoadingVideo: false));
      session.cancel();
    }
  }

  Future<String> getFilterImage({required ShortsEditorLoadedState state}) async {
    ByteData assetData = await rootBundle.load(state.filterPath);
    String tempDir = (await getTemporaryDirectory()).path;
    String assetFileName = state.filterPath.split('/').last;
    File imageFile = File('$tempDir/shortsVideo/$assetFileName');
    await imageFile.writeAsBytes(assetData.buffer.asUint8List());
    return imageFile.path;
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
