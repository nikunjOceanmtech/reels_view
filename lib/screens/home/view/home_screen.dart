import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:reels_view/screens/home/view/recode_screen.dart';
import 'package:reels_view/screens/home/view/video_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<XFile> listOfVideo = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var videoFile = await Navigator.push(context, MaterialPageRoute(builder: (context) => RecodeScreen()));
                listOfVideo.add(videoFile);
                setState(() {});
              },
              child: Text("Recode First Video"),
            ),
            ElevatedButton(
              onPressed: () async {
                var videoFile = await Navigator.push(context, MaterialPageRoute(builder: (context) => RecodeScreen()));
                listOfVideo.add(videoFile);
                setState(() {});
              },
              child: Text("Recode Second Video"),
            ),
            ElevatedButton(
              onPressed: () async {
                print("=======${listOfVideo.length == 1}");
                if (listOfVideo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please Recode First and second video")),
                  );
                  return;
                } else if (listOfVideo.length == 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please Recode Second Video")),
                  );
                  return;
                }
                print("=======+${listOfVideo.map((e) => e.path)}");
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoView(
                      videoFile1: File(listOfVideo.first.path),
                      videoFile2: File(listOfVideo.last.path),
                    ),
                  ),
                );
              },
              child: Text("Set Output Video"),
            ),
          ],
        ),
      ),
    );
  }
}
