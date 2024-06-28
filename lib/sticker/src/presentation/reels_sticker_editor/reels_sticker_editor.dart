import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:reels_view/sticker/src/domain/models/editable_items.dart';
import 'package:reels_view/sticker/src/domain/models/painting_model.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/control_provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:reels_view/sticker/src/presentation/bar_tools/top_tools.dart';
import 'package:reels_view/sticker/src/presentation/draggable_items/delete_item.dart';
import 'package:reels_view/sticker/src/presentation/draggable_items/draggable_widget.dart';
import 'package:reels_view/sticker/src/presentation/painting_view/painting.dart';
import 'package:reels_view/sticker/src/presentation/painting_view/widgets/sketcher.dart';
import 'package:reels_view/sticker/src/presentation/text_editor_view/TextEditor.dart';
import 'package:reels_view/sticker/src/presentation/utils/constants/app_enums.dart';
import 'package:reels_view/sticker/src/presentation/utils/modal_sheets.dart';
import 'package:reels_view/sticker/src/presentation/widgets/scrollable_pageView.dart';
import 'package:screenshot/screenshot.dart';

class ReelsStickerEditor extends StatefulWidget {
  final List<String>? fontFamilyList;
  final bool? isCustomFontList;
  final Widget? middleBottomWidget;
  final Widget? onDoneButtonStyle;
  final Future<bool>? onBackPress;
  Color? editorBackgroundColor;
  final Widget videoView;
  final bool isShowFilterIcon;
  final void Function() onMusicTap;
  final void Function() onEffectTap;
  final void Function() onFilterDoneTap;
  final void Function() onFilterCancelTap;
  final void Function() onVidepPlayOrPause;
  final void Function(String imagePath) onDownloadTap;
  final void Function(String imagePath) onNextButtonTap;
  final Widget playPauseView;

  ReelsStickerEditor({
    super.key,
    this.middleBottomWidget,
    this.isCustomFontList,
    this.fontFamilyList,
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
  ReelsStickerEditorState createState() => ReelsStickerEditorState();
}

class ReelsStickerEditorState extends State<ReelsStickerEditor> {
  final GlobalKey contentKey = GlobalKey();
  EditableItem? _activeItem;
  Offset _initPos = const Offset(0, 0);
  Offset _currentPos = const Offset(0, 0);
  double _currentScale = 1;
  double _currentRotation = 0;
  bool isDeletePosition = false;
  bool _inAction = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        var control = Provider.of<ControlNotifier>(context, listen: false);
        control.middleBottomWidget = widget.middleBottomWidget;
        control.isCustomFontList = widget.isCustomFontList ?? false;
        if (widget.fontFamilyList != null) {
          control.fontList = widget.fontFamilyList;
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: popScope,
      child: Material(
        color: widget.editorBackgroundColor == Colors.transparent
            ? Colors.black
            : widget.editorBackgroundColor ?? Colors.black,
        child:
            Consumer5<ControlNotifier, DraggableWidgetNotifier, ScrollNotifier, PaintingNotifier, TextEditingNotifier>(
          builder: (context, controlNotifier, itemProvider, scrollProvider, paintingProvider, editingProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ScrollablePageView(
                    scrollPhysics: controlNotifier.mediaPath.isEmpty &&
                        itemProvider.draggableWidget.isEmpty &&
                        !controlNotifier.isPainting &&
                        !controlNotifier.isTextEditing,
                    pageController: scrollProvider.pageController,
                    gridController: scrollProvider.gridController,
                    mainView: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: controlNotifier.isTextEditing
                              ? BorderRadius.zero
                              : BorderRadius.only(
                                  bottomLeft: Radius.circular(25.r),
                                  bottomRight: Radius.circular(25.r),
                                ),
                          child: widget.videoView,
                        ),
                        Screenshot(
                          controller: GetContorller.screenshotController,
                          child: AspectRatio(
                            aspectRatio: 9 / 16,
                            child: GestureDetector(
                              onScaleStart: onScaleStart,
                              onScaleUpdate: onScaleUpdate,
                              onTap: () {},
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: RepaintBoundary(
                                  key: contentKey,
                                  child: dataView(
                                    itemProvider: itemProvider,
                                    context: context,
                                    paintingProvider: paintingProvider,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !controlNotifier.isTextEditing && !controlNotifier.isPainting,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: TopTools(
                              isShowFilterIcon: widget.isShowFilterIcon,
                              contentKey: contentKey,
                              context: context,
                              onMusicTap: widget.onMusicTap,
                              onEffectTap: widget.onEffectTap,
                              onDownloadTap: widget.onDownloadTap,
                              onFilterCancelTap: widget.onFilterCancelTap,
                              onFilterDoneTap: widget.onFilterDoneTap,
                              editingProvider: editingProvider,
                            ),
                          ),
                        ),
                        DeleteItem(
                          activeItem: _activeItem,
                          animationsDuration: const Duration(
                            milliseconds: 300,
                          ),
                          isDeletePosition: isDeletePosition,
                        ),
                        Visibility(
                          visible: controlNotifier.isTextEditing,
                          child: TextEditor(context: context),
                        ),
                        Visibility(
                          visible: controlNotifier.isPainting,
                          child: const Painting(),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.isShowFilterIcon
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                            margin: EdgeInsets.symmetric(vertical: 20.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: Text(
                              "FILTER",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      )
                    : controlNotifier.isTextEditing
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reels",
                                  style: TextStyle(
                                    color: widget.isShowFilterIcon ? Colors.transparent : Colors.white,
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Visibility(
                                  child: InkWell(
                                    onTap: widget.onVidepPlayOrPause,
                                    child: widget.playPauseView,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (itemProvider.draggableWidget.isEmpty) {
                                      widget.onNextButtonTap("");
                                    } else {
                                      String imagePath = "";
                                      await GetContorller.screenshotController.capture().then((image) async {
                                        if (image != null) {
                                          File file = File(await GetContorller.setFileInDevice('tempStickerImage.png'));
                                          file.writeAsBytes(image);
                                          imagePath = file.path;
                                        }
                                      });
                                      if (imagePath.isNotEmpty) {
                                        widget.onNextButtonTap(imagePath);
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                                    margin: EdgeInsets.symmetric(vertical: 27.h),
                                    decoration: BoxDecoration(
                                      color: widget.isShowFilterIcon ? Colors.transparent : Color(0xff084277),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      "Next",
                                      style: TextStyle(
                                        color: widget.isShowFilterIcon ? Colors.transparent : Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget dataView({
    required PaintingNotifier paintingProvider,
    required DraggableWidgetNotifier itemProvider,
    required BuildContext context,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        child: Stack(
          // alignment: Alignment.center,
          children: [
            ...itemProvider.draggableWidget.map(
              (EditableItem editableItem) {
                return DraggableWidget(
                  context: context,
                  draggableWidget: editableItem,
                  onPointerDown: (details) => updateItemPosition(editableItem, details),
                  onPointerUp: (details) => deleteItemOnCoordinates(editableItem, details),
                  onPointerMove: (details) => deletePosition(editableItem, details),
                );
              },
            ),
            IgnorePointer(
              ignoring: true,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: RepaintBoundary(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<List<PaintingModel>>(
                        stream: paintingProvider.linesStreamController.stream,
                        builder: (context, snapshot) {
                          return CustomPaint(
                            painter: Sketcher(lines: paintingProvider.lines),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> popScope() async {
    final controlNotifier = Provider.of<ControlNotifier>(
      context,
      listen: false,
    );
    if (controlNotifier.isTextEditing) {
      controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
      return false;
    } else if (controlNotifier.isPainting) {
      controlNotifier.isPainting = !controlNotifier.isPainting;
      return false;
    } else if (!controlNotifier.isTextEditing && !controlNotifier.isPainting) {
      return widget.onBackPress ?? exitDialog(context: context);
    }
    return false;
  }

  void onScaleStart(ScaleStartDetails details) {
    if (_activeItem == null) {
      return;
    }
    _initPos = details.focalPoint;
    _currentPos = _activeItem!.position;
    _currentScale = _activeItem!.scale;
    _currentRotation = _activeItem!.rotation;
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (_activeItem == null) {
      return;
    }
    final delta = details.focalPoint - _initPos;

    final left = (delta.dx / MediaQuery.of(context).size.width) + _currentPos.dx;
    final top = (delta.dy / MediaQuery.of(context).size.height) + _currentPos.dy;

    setState(() {
      _activeItem!.position = Offset(left, top);
      _activeItem!.rotation = details.rotation + _currentRotation;
      _activeItem!.scale = details.scale * _currentScale;
    });
  }

  void deletePosition(EditableItem item, PointerMoveEvent details) {
    if (item.type == ItemType.text && item.position.dy >= 0.35 && item.position.dx >= -0.2 && item.position.dx <= 0.2) {
      setState(() {
        isDeletePosition = true;
        item.deletePosition = true;
      });
    } else if (item.type == ItemType.gif &&
        item.position.dy >= 0.3 &&
        item.position.dx >= -0.35 &&
        item.position.dx <= 0.15) {
      setState(() {
        isDeletePosition = true;
        item.deletePosition = true;
      });
    } else {
      setState(() {
        isDeletePosition = false;
        item.deletePosition = false;
      });
    }
  }

  void deleteItemOnCoordinates(EditableItem item, PointerUpEvent details) {
    var itemProvider = Provider.of<DraggableWidgetNotifier>(context, listen: false).draggableWidget;
    _inAction = false;
    if (item.type == ItemType.image) {
    } else if ((item.type == ItemType.text &&
            item.position.dy >= 0.35 &&
            item.position.dx >= -0.2 &&
            item.position.dx <= 0.2) ||
        (item.type == ItemType.gif &&
            item.position.dy >= 0.3 &&
            item.position.dx >= -0.35 &&
            item.position.dx <= 0.15)) {
      setState(() {
        itemProvider.removeAt(itemProvider.indexOf(item));
        HapticFeedback.heavyImpact();
      });
    } else {
      setState(() {
        _activeItem = null;
      });
    }
    setState(() {
      _activeItem = null;
    });
  }

  void updateItemPosition(EditableItem item, PointerDownEvent details) {
    if (_inAction) {
      return;
    }

    _inAction = true;
    _activeItem = item;
    _initPos = details.position;
    _currentPos = item.position;
    _currentScale = item.scale;
    _currentRotation = item.rotation;

    HapticFeedback.lightImpact();
  }
}

class GetContorller {
  static ScreenshotController screenshotController = ScreenshotController();
  static bool hideWidget = false;

  static Future<String> commonDirectoryGet() async {
    final directory = await getTemporaryDirectory();
    final Directory directoryFolder = Directory('${directory.path}/shortsVideo/');
    if (await directoryFolder.exists()) {
      return '${directory.path}/shortsVideo';
    } else {
      await directoryFolder.create(recursive: true);
      return '${directory.path}/shortsVideo';
    }
  }

  static Future<String> setFileInDevice(String fileName) async {
    final directory = await commonDirectoryGet();
    return '$directory/$fileName';
  }
}
