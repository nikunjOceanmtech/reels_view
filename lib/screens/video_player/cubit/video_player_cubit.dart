import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

part 'video_player_state.dart';

class VideoPlayerCubit extends Cubit<double> {
  VideoPlayerCubit() : super(0);

  VideoPlayerController? controller;
  Uri uri = Uri.parse('https://files.testfile.org/Video%20MP4%2FOcean%20-%20testfile.org.mp4');

  void loadVideo() {
    print("===========${DateTime.now()}");
    controller = VideoPlayerController.networkUrl(uri);
    controller?.initialize().then(
      (value) {
        print("===========${DateTime.now()}");
        controller!.play();
        controller!.setLooping(true);
        // emit(Random().nextDouble());
        // controller!.addListener(() => emit(Random().nextDouble()));
      },
    ).catchError(
      (e) {
        print("==========+$e");
      },
    );
  }

  Future<VideoPlayerController> video1() async {
    print("===========${DateTime.now()}");
    VideoPlayerController videoPlayerController = VideoPlayerController.networkUrl(uri);
    await videoPlayerController.initialize();
    print("===========${DateTime.now()}");
    videoPlayerController.setCaptionOffset(Duration(seconds: 5));
    videoPlayerController.play();
    videoPlayerController.setLooping(true);
    return videoPlayerController;
  }

  void playOrPauseVideo() {
    if (controller != null) {
      if (controller!.value.isPlaying) {
        controller!.pause();
      } else {
        controller!.play();
      }
    }
  }
}
