import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class RecodeScreen extends StatefulWidget {
  const RecodeScreen({super.key});

  @override
  State<RecodeScreen> createState() => _RecodeScreenState();
}

class _RecodeScreenState extends State<RecodeScreen> {
  late CameraController controller;
  bool isInitialized = false;

  @override
  void initState() {
    initilizeCamera();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    isInitialized = false;
    super.dispose();
  }

  Future<void> initilizeCamera() async {
    List<CameraDescription> availableCamerasList = await availableCameras();
    List<CameraDescription> listOfCameras =
        availableCamerasList.where((element) => element.lensDirection == CameraLensDirection.back).toList();
    if (listOfCameras.isNotEmpty) {
      controller = CameraController(
        listOfCameras.first,
        ResolutionPreset.max,
        enableAudio: true,
        fps: 30,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await controller.initialize().then((value) => setState(() => isInitialized = true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isInitialized
          ? Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: CameraPreview(controller),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.startVideoRecording();
                      await Future.delayed(Duration(seconds: 5), () async {
                        XFile recodingFile = await controller.stopVideoRecording();
                        Navigator.pop(context, recodingFile);
                      });
                    },
                    child: Text("Start Recording"),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
