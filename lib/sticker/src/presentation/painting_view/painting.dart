// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reels_view/sticker/src/domain/models/painting_model.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/control_provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:reels_view/sticker/src/presentation/painting_view/widgets/sketcher.dart';
import 'package:reels_view/sticker/src/presentation/painting_view/widgets/top_painting_tools.dart';
import 'package:reels_view/sticker/src/presentation/widgets/color_selector.dart';
import 'package:reels_view/sticker/src/presentation/widgets/size_slider_selector.dart';

class Painting extends StatefulWidget {
  const Painting({super.key});

  @override
  State<Painting> createState() => _PaintingState();
}

class _PaintingState extends State<Painting> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PaintingNotifier>(context, listen: false)
        ..linesStreamController = StreamController<List<PaintingModel>>.broadcast()
        ..currentLineStreamController = StreamController<PaintingModel>.broadcast();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// instance of painting model
    PaintingModel? line;

    /// screen size
    var screenSize = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

    /// on gestures start
    void onPanStart(DragStartDetails details, PaintingNotifier paintingNotifier, ControlNotifier controlProvider) {
      final box = context.findRenderObject() as RenderBox;
      final offset = box.globalToLocal(details.globalPosition);
      final point = Point(offset.dx, offset.dy);
      final points = [point];

      /// validate allow pan area
      if (point.y >= 4 &&
          point.y <=
              (Platform.isIOS
                  ? (screenSize.size.height - 132) - screenSize.viewPadding.top
                  : screenSize.size.height - 132)) {
        line = PaintingModel(points, paintingNotifier.lineWidth, 1, 1, false,
            controlProvider.colorList![paintingNotifier.lineColor], 1, true, paintingNotifier.paintingType);
      }
    }

    /// on gestures update
    void onPanUpdate(DragUpdateDetails details, PaintingNotifier paintingNotifier, ControlNotifier controlNotifier) {
      final box = context.findRenderObject() as RenderBox;
      final offset = box.globalToLocal(details.globalPosition);
      final point = Point(offset.dx, offset.dy);
      final points = [...line!.points, point];

      /// validate allow pan area
      if (point.y >= 6 &&
          point.y <=
              (Platform.isIOS
                  ? (screenSize.size.height - 132) - screenSize.viewPadding.top
                  : screenSize.size.height - 132)) {
        line = PaintingModel(points, paintingNotifier.lineWidth, 1, 1, false,
            controlNotifier.colorList![paintingNotifier.lineColor], 1, true, paintingNotifier.paintingType);
        paintingNotifier.currentLineStreamController.add(line!);
      }
    }

    /// on gestures end
    void onPanEnd(DragEndDetails details, PaintingNotifier paintingNotifier) {
      paintingNotifier.lines = List.from(paintingNotifier.lines)..add(line!);
      line = null;
      paintingNotifier.linesStreamController.add(paintingNotifier.lines);
    }

    /// paint current line
    Widget renderCurrentLine(BuildContext context, PaintingNotifier paintingNotifier, ControlNotifier controlNotifier) {
      return GestureDetector(
        onPanStart: (details) {
          onPanStart(details, paintingNotifier, controlNotifier);
        },
        onPanUpdate: (details) {
          onPanUpdate(details, paintingNotifier, controlNotifier);
        },
        onPanEnd: (details) {
          onPanEnd(details, paintingNotifier);
        },
        child: RepaintBoundary(
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: Platform.isIOS
                      ? (screenSize.size.height - 132) - screenSize.viewPadding.top
                      : MediaQuery.of(context).size.height - 132,
                  child: StreamBuilder<PaintingModel>(
                      stream: paintingNotifier.currentLineStreamController.stream,
                      builder: (context, snapshot) {
                        return CustomPaint(
                          painter: Sketcher(
                            lines: line == null ? [] : [line!],
                          ),
                        );
                      })),
            ),
          ),
        ),
      );
    }

    /// return Painting board
    return Consumer2<ControlNotifier, PaintingNotifier>(
      builder: (context, controlNotifier, paintingNotifier, child) {
        return WillPopScope(
          onWillPop: () async {
            controlNotifier.isPainting = false;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              paintingNotifier.closeConnection();
            });
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                /// render current line
                renderCurrentLine(context, paintingNotifier, controlNotifier),

                /// select line width
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 140),
                    child: SizeSliderWidget(),
                  ),
                ),
                const SafeArea(child: TopPaintingTools()),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                    child: ColorSelector(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
