import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reels_view/di/get_it.dart';
import 'package:reels_view/screens/camera_view/view/camera_screen.dart';
import 'package:reels_view/screens/shorts_editor/view/shorts_editor_screen.dart';
import 'package:reels_view/screens/video_player/view/video_player_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
              ? WebViewScreen()
              : 1 == 1
                  ? VideoPlayerScreen()
                  : 1 == 1
                      ? CameraScreen()
                      : ShortsEditorScreen(videoPath: ''),
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    webview();
    super.initState();
  }

  WebViewController? webViewController;

  void webview() {
    webViewController = WebViewController()
      ..setBackgroundColor(Colors.black)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {},
        onPageFinished: (progress) {
          webViewController?.clearCache();
          webViewController?.clearLocalStorage();
        },
        onPageStarted: (progress) {},
        onHttpAuthRequest: (progress) {},
        onUrlChange: (progress) {},
        onWebResourceError: (progress) {},
        onHttpError: (progress) {},
      ))
      ..loadRequest(
        Uri.parse(
          "https://iframe.mediadelivery.net/embed/84972/29d0d68f-bc31-4c9b-bd6a-bcbc0c526382?autoplay=true&loop=true&muted=true&preload=true&responsive=true&mute=falseplay=false&fullScreen=true",
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: webViewController != null ? WebViewWidget(controller: webViewController!) : CircularProgressIndicator(),
      ),
    );
  }
}
