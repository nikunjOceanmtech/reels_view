// ignore_for_file: must_be_immutable, constant_identifier_names
library stories_editor;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/control_provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:reels_view/sticker/src/presentation/reels_sticker_editor/reels_sticker_editor.dart';

class StoriesEditor extends StatefulWidget {
  final List<String>? fontFamilyList;
  final bool? isCustomFontList;
  final Widget? middleBottomWidget;
  final Widget? onDoneButtonStyle;
  final Future<bool>? onBackPress;
  final Color? editorBackgroundColor;
  final void Function() onMusicTap;
  final void Function() onEffectTap;
  final void Function(String imagePath) onDownloadTap;
  final void Function() onFilterDoneTap;
  final void Function() onFilterCancelTap;
  final void Function() onVidepPlayOrPause;
  final void Function(String imagePath) onNextButtonTap;
  final Widget videoView;
  final bool isShowFilterIcon;
  final Widget playPauseView;

  const StoriesEditor({
    super.key,
    this.middleBottomWidget,
    this.fontFamilyList,
    this.isCustomFontList,
    this.onBackPress,
    this.onDoneButtonStyle,
    this.editorBackgroundColor,
    required this.onMusicTap,
    required this.onEffectTap,
    required this.onDownloadTap,
    required this.videoView,
    required this.isShowFilterIcon,
    required this.onFilterCancelTap,
    required this.onVidepPlayOrPause,
    required this.onFilterDoneTap,
    required this.onNextButtonTap,
    required this.playPauseView,
  });

  @override
  StoriesEditorState createState() => StoriesEditorState();
}

class StoriesEditorState extends State<StoriesEditor> {
  @override
  void initState() {
    // Paint.enableDithering = true;
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xff084277),
          statusBarIconBrightness: Brightness.light,
        ),
      );
    } else if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xff084277),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ControlNotifier()),
            ChangeNotifierProvider(create: (_) => ScrollNotifier()),
            ChangeNotifierProvider(create: (_) => DraggableWidgetNotifier()),
            ChangeNotifierProvider(create: (_) => PaintingNotifier()),
            ChangeNotifierProvider(create: (_) => TextEditingNotifier()),
          ],
          child: ReelsStickerEditor(
            fontFamilyList: widget.fontFamilyList,
            isCustomFontList: widget.isCustomFontList,
            middleBottomWidget: widget.middleBottomWidget,
            onDoneButtonStyle: widget.onDoneButtonStyle,
            onBackPress: widget.onBackPress,
            editorBackgroundColor: widget.editorBackgroundColor,
            onMusicTap: widget.onMusicTap,
            onEffectTap: widget.onEffectTap,
            onDownloadTap: widget.onDownloadTap,
            onNextButtonTap: widget.onNextButtonTap,
            videoView: widget.videoView,
            isShowFilterIcon: widget.isShowFilterIcon,
            playPauseView: widget.playPauseView,
            onFilterCancelTap: widget.onFilterCancelTap,
            onVidepPlayOrPause: widget.onVidepPlayOrPause,
            onFilterDoneTap: widget.onFilterDoneTap,
          ),
        ),
      ),
    );
  }
}
