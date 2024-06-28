import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/control_provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/text_editing_notifier.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FocusNode textNode = FocusNode();
    return Consumer2<TextEditingNotifier, ControlNotifier>(
      builder: (context, editorNotifier, controlNotifier, child) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 100,
            ),
            child: IntrinsicWidth(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: text(
                      editorNotifier: editorNotifier,
                      textNode: textNode,
                      controlNotifier: controlNotifier,
                      paintingStyle: PaintingStyle.fill,
                    ),
                  ),
                  textField(
                    editorNotifier: editorNotifier,
                    textNode: textNode,
                    controlNotifier: controlNotifier,
                    paintingStyle: PaintingStyle.stroke,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget text({
    required TextEditingNotifier editorNotifier,
    required FocusNode textNode,
    required ControlNotifier controlNotifier,
    required PaintingStyle paintingStyle,
  }) {
    return Text(
      editorNotifier.textController.text,
      textAlign: editorNotifier.textAlign,
      style: TextStyle(
        fontFamily: controlNotifier.fontList?[editorNotifier.fontFamilyIndex],
        color:
            controlNotifier.isTextEditing ? Colors.transparent : controlNotifier.colorList![editorNotifier.textColor],
        fontSize: editorNotifier.textSize,
        background: Paint()
          ..strokeWidth = 20.0
          ..color = editorNotifier.backGroundColor
          ..style = paintingStyle
          ..strokeJoin = StrokeJoin.round
          ..filterQuality = FilterQuality.high
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1),
      ),
    );
  }

  Widget textField({
    required TextEditingNotifier editorNotifier,
    required FocusNode textNode,
    required ControlNotifier controlNotifier,
    required PaintingStyle paintingStyle,
  }) {
    return TextField(
      focusNode: textNode,
      autofocus: true,
      textInputAction: TextInputAction.newline,
      controller: editorNotifier.textController,
      textAlign: editorNotifier.textAlign,
      style: TextStyle(
        fontFamily: controlNotifier.fontList![editorNotifier.fontFamilyIndex],
        shadows: [
          Shadow(
            offset: const Offset(1.0, 1.0),
            blurRadius: 3.0,
            color: 1 == 1
                ? Colors.transparent
                : editorNotifier.textColor == Colors.black
                    ? Colors.white54
                    : Colors.black,
          )
        ],
        backgroundColor: Colors.redAccent,
      ).copyWith(
        decoration: TextDecoration.none,
        color: editorNotifier.backGroundColor == Colors.transparent
            ? controlNotifier.colorList![editorNotifier.textColor]
            : editorNotifier.backGroundColor == Colors.black
                ? Colors.white
                : 1 == 1
                    ? Colors.black
                    : controlNotifier.colorList![editorNotifier.textColor],
        fontSize: editorNotifier.textSize,
        background: Paint()
          ..strokeWidth = 20
          ..color = editorNotifier.backGroundColor
          ..style = paintingStyle
          ..strokeJoin = StrokeJoin.round
          ..filterQuality = FilterQuality.high
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1)
          ..style = PaintingStyle.stroke,
        shadows: [
          Shadow(
            offset: const Offset(1.0, 1.0),
            blurRadius: 3.0,
            color: 1 == 1
                ? Colors.transparent
                : editorNotifier.textColor == Colors.black
                    ? Colors.white54
                    : Colors.black,
          ),
        ],
      ),
      cursorColor: controlNotifier.colorList![editorNotifier.textColor],
      minLines: 1,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
      onChanged: (value) => editorNotifier.text = value,
    );
  }
}
