import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reels_view/di/get_it.dart';
import 'package:reels_view/screens/camera_view/view/camera_screen.dart';
import 'package:reels_view/screens/home/view/home_screen.dart';
import 'package:reels_view/screens/shorts_editor/view/shorts_editor_screen.dart';

void main() {
  unawaited(init());

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var pixelRatio = View.of(context).devicePixelRatio;
    var logicalScreenSize = View.of(context).physicalSize / pixelRatio;
    var logicalWidth = logicalScreenSize.width;

    return SafeArea(
      child: ScreenUtilInit(
        designSize: logicalWidth > 600 ? const Size(834, 1194) : const Size(414, 896),
        child: MaterialApp(
          home: 1 == 1
              ? HomeScreen()
              : 1 == 1
                  ? CameraScreen()
                  : ShortsEditorScreen(videoPath: ''),
        ),
      ),
    );
  }
}
