import 'package:get_it/get_it.dart';
import 'package:reels_view/screens/camera_view/cubit/camera_cubit.dart';
import 'package:reels_view/screens/shorts_editor/cubit/shorts_editor_cubit.dart';
import 'package:reels_view/screens/video_player/cubit/video_player_cubit.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerFactory<CameraCubit>(() => CameraCubit());
  getItInstance.registerFactory<ShortsEditorCubit>(() => ShortsEditorCubit());
  getItInstance.registerFactory<VideoPlayerCubit>(() => VideoPlayerCubit());
}
