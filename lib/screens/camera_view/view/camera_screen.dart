import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reels_view/screens/camera_view/cubit/camera_cubit.dart';
import 'package:reels_view/di/get_it.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraCubit cameraCubit;

  @override
  void initState() {
    cameraCubit = getItInstance<CameraCubit>();
    super.initState();
    cameraCubit.loadCamera();
  }

  @override
  void dispose() {
    cameraCubit.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      bloc: cameraCubit,
      builder: (_, state) {
        if (state is CameraLoadedState) {
          return Scaffold(
            body: (cameraCubit.cameraController != null && (cameraCubit.cameraController?.value.isInitialized ?? false))
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      CameraPreview(cameraCubit.cameraController!),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (state.isVideoRecoding) {
                                  cameraCubit.stopVideoRecode(state: state);
                                } else {
                                  cameraCubit.startVideoRecode(state: state);
                                }
                              },
                              child: Text(state.isVideoRecoding ? "Stop Recode" : "Start Recode"),
                            ),
                            SizedBox(width: 10),
                            cameraCubit.videoFile != null
                                ? ElevatedButton(
                                    onPressed: () {
                                      cameraCubit.nextButton(context: context);
                                    },
                                    child: Text("Next"),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
