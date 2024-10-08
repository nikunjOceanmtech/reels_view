import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reels_view/sticker/src/domain/models/editable_items.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/control_provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:reels_view/sticker/src/presentation/utils/constants/app_enums.dart';
import 'package:reels_view/sticker/src/presentation/widgets/animated_onTap_button.dart';

class DraggableWidget extends StatelessWidget {
  final EditableItem draggableWidget;
  final Function(PointerDownEvent)? onPointerDown;
  final Function(PointerUpEvent)? onPointerUp;
  final Function(PointerMoveEvent)? onPointerMove;
  final BuildContext context;
  const DraggableWidget({
    super.key,
    required this.context,
    required this.draggableWidget,
    this.onPointerDown,
    this.onPointerUp,
    this.onPointerMove,
  });

  @override
  Widget build(BuildContext context) {
    var controlProvider = Provider.of<ControlNotifier>(this.context, listen: false);
    Widget? overlayWidget;

    if (draggableWidget.type == ItemType.text) {
      overlayWidget = IntrinsicWidth(
        child: IntrinsicHeight(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 50,
              minWidth: 50,
              maxWidth: MediaQuery.of(context).size.width - 240,
            ),
            width: draggableWidget.deletePosition ? 100 : null,
            height: draggableWidget.deletePosition ? 100 : null,
            child: AnimatedOnTapButton(
              onTap: draggableWidget.isEmoji ? () {} : () => _onTap(context, draggableWidget, controlProvider),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: _text(
                      background: true,
                      paintingStyle: PaintingStyle.fill,
                      controlNotifier: controlProvider,
                    ),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: Center(
                      child: _text(
                        background: true,
                        paintingStyle: PaintingStyle.stroke,
                        controlNotifier: controlProvider,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 2.5, top: 2),
                    child: Stack(
                      children: [
                        Center(
                          child: _text(paintingStyle: PaintingStyle.fill, controlNotifier: controlProvider),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else if (draggableWidget.type == ItemType.image) {
      overlayWidget = const SizedBox.shrink();
    } else if (draggableWidget.type case ItemType.gif) {
      if (draggableWidget.child != null) {
        overlayWidget = draggableWidget.child!;
      }
    } else if (draggableWidget.type == ItemType.video) {
      overlayWidget = const Center();
    }

    return AnimatedAlignPositioned(
      duration: const Duration(milliseconds: 50),
      dy: (draggableWidget.deletePosition
          ? deleteTopOffset()
          : (draggableWidget.position.dy * MediaQuery.of(context).size.height)),
      dx: (draggableWidget.deletePosition ? 0 : (draggableWidget.position.dx * MediaQuery.of(context).size.width)),
      alignment: Alignment.center,
      child: Transform.scale(
        scale: draggableWidget.deletePosition ? deleteScale() : draggableWidget.scale,
        child: Transform.rotate(
          angle: draggableWidget.rotation,
          child: Listener(
            onPointerDown: onPointerDown,
            onPointerUp: onPointerUp,
            onPointerMove: onPointerMove,
            child: overlayWidget,
          ),
        ),
      ),
    );
  }

  /// text widget
  Widget _text({
    required ControlNotifier controlNotifier,
    required PaintingStyle paintingStyle,
    bool background = false,
  }) {
    if (draggableWidget.animationType == TextAnimationType.none) {
      return Text(
        draggableWidget.text,
        textAlign: draggableWidget.textAlign,
        style: _textStyle(controlNotifier: controlNotifier, paintingStyle: paintingStyle, background: background),
      );
    } else {
      // return DefaultTextStyle(
      //   style: _textStyle(controlNotifier: controlNotifier, paintingStyle: paintingStyle, background: background),
      //   child: AnimatedTextKit(
      //     repeatForever: true,
      //     onTap: () => _onTap(context, draggableWidget, controlNotifier),
      //     animatedTexts: [
      //       if (draggableWidget.animationType == TextAnimationType.scale)
      //         ScaleAnimatedText(draggableWidget.text, duration: const Duration(milliseconds: 1200)),
      //       if (draggableWidget.animationType == TextAnimationType.fade)
      //         ...draggableWidget.textList.map(
      //           (item) => FadeAnimatedText(item, duration: const Duration(milliseconds: 1200)),
      //         ),
      //       if (draggableWidget.animationType == TextAnimationType.typer)
      //         TyperAnimatedText(draggableWidget.text, speed: const Duration(milliseconds: 500)),
      //       if (draggableWidget.animationType == TextAnimationType.typeWriter)
      //         TypewriterAnimatedText(
      //           draggableWidget.text,
      //           speed: const Duration(milliseconds: 500),
      //         ),
      //       if (draggableWidget.animationType == TextAnimationType.wavy)
      //         WavyAnimatedText(
      //           draggableWidget.text,
      //           speed: const Duration(milliseconds: 500),
      //         ),
      //       if (draggableWidget.animationType == TextAnimationType.flicker)
      //         FlickerAnimatedText(
      //           draggableWidget.text,
      //           speed: const Duration(milliseconds: 1200),
      //         ),
      //     ],
      //   ),
      // );
      return const SizedBox.shrink();
    }
  }

  _textStyle({
    required ControlNotifier controlNotifier,
    required PaintingStyle paintingStyle,
    bool background = false,
  }) {
    return TextStyle(
      fontFamily: controlNotifier.fontList![draggableWidget.fontFamily],
      // package: controlNotifier.isCustomFontList ? null : 'stories_editor',
      fontWeight: FontWeight.w500,
    ).copyWith(
      color: background ? Colors.black : draggableWidget.textColor,
      fontSize: draggableWidget.deletePosition ? 8 : draggableWidget.fontSize,
      background: Paint()
        ..strokeWidth = 20.0
        ..color = draggableWidget.backGroundColor
        ..style = paintingStyle
        ..strokeJoin = StrokeJoin.round
        ..filterQuality = FilterQuality.high
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1),
    );
  }

  deleteScale() {
    double scale = 0.0;
    if (draggableWidget.type == ItemType.text) {
      scale = 1.5;
      return scale;
    } else if (draggableWidget.type == ItemType.gif) {
      scale = 0.1;
      return scale;
    }
  }

  void _onTap(BuildContext context, EditableItem item, ControlNotifier controlNotifier) {
    var editorProvider = Provider.of<TextEditingNotifier>(this.context, listen: false);
    var itemProvider = Provider.of<DraggableWidgetNotifier>(this.context, listen: false);

    editorProvider.textController.text = item.text.trim();
    editorProvider.text = item.text.trim();
    editorProvider.fontFamilyIndex = item.fontFamily;
    editorProvider.textSize = item.fontSize;
    editorProvider.backGroundColor = item.backGroundColor;
    editorProvider.textAlign = item.textAlign;
    editorProvider.textColor = controlNotifier.colorList!.indexOf(item.textColor);
    editorProvider.animationType = item.animationType;
    editorProvider.textList = item.textList;
    editorProvider.fontAnimationIndex = item.fontAnimationIndex;
    itemProvider.draggableWidget.removeAt(itemProvider.draggableWidget.indexOf(item));
    editorProvider.fontFamilyController = PageController(
      initialPage: item.fontFamily,
      viewportFraction: .1,
    );

    controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
  }

  deleteTopOffset() {
    if (draggableWidget.type == ItemType.text) {
      return MediaQuery.of(context).size.width / 1.22;
    } else if (draggableWidget.type == ItemType.gif) {
      return MediaQuery.of(context).size.width / 1.22;
    }
  }
}
