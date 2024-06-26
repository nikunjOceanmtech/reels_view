// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reels_view/sticker/src/domain/models/editable_items.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/control_provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:reels_view/sticker/src/presentation/text_editor_view/widgets/animation_selector.dart';
import 'package:reels_view/sticker/src/presentation/text_editor_view/widgets/font_selector.dart';
import 'package:reels_view/sticker/src/presentation/text_editor_view/widgets/text_field_widget.dart';
import 'package:reels_view/sticker/src/presentation/text_editor_view/widgets/top_text_tools.dart';
import 'package:reels_view/sticker/src/presentation/utils/constants/app_enums.dart';
import 'package:reels_view/sticker/src/presentation/widgets/color_selector.dart';
import 'package:reels_view/sticker/src/presentation/widgets/size_slider_selector.dart';

class TextEditor extends StatefulWidget {
  final BuildContext context;
  const TextEditor({super.key, required this.context});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  List<String> splitList = [];
  String sequenceList = '';
  String lastSequenceList = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final editorNotifier = Provider.of<TextEditingNotifier>(widget.context, listen: false);
        editorNotifier
          ..textController.text = editorNotifier.text
          ..fontFamilyController = PageController(viewportFraction: .125);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Consumer2<ControlNotifier, TextEditingNotifier>(
        builder: (_, controlNotifier, editorNotifier, __) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: () => onTap(
                context: context,
                controlNotifier: controlNotifier,
                editorNotifier: editorNotifier,
              ),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: TextFieldWidget(),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: SizeSliderWidget(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: TopTextTools(
                        onDone: () => onTap(
                          context: context,
                          controlNotifier: controlNotifier,
                          editorNotifier: editorNotifier,
                        ),
                      ),
                    ),
                    Positioned(
                      // bottom: MediaQuery.of(context).viewInsets.bottom - 80,
                      child: Visibility(
                        visible: editorNotifier.isFontFamily && !editorNotifier.isTextAnimation,
                        child: const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: FontSelector(),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !editorNotifier.isFontFamily && !editorNotifier.isTextAnimation,
                      child: const Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: ColorSelector(),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      child: Visibility(
                        visible: editorNotifier.isTextAnimation,
                        child: const AnimationSelector(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onTap({
    required BuildContext context,
    required ControlNotifier controlNotifier,
    required TextEditingNotifier editorNotifier,
  }) {
    final editableItemNotifier = Provider.of<DraggableWidgetNotifier>(
      context,
      listen: false,
    );

    if (editorNotifier.text.trim().isNotEmpty) {
      splitList = editorNotifier.text.split(' ');
      for (int i = 0; i < splitList.length; i++) {
        if (i == 0) {
          editorNotifier.textList.add(splitList[0]);
          sequenceList = splitList[0];
        } else {
          lastSequenceList = sequenceList;
          editorNotifier.textList.add('$sequenceList ${splitList[i]}');
          sequenceList = '$lastSequenceList ${splitList[i]}';
        }
      }

      editableItemNotifier.draggableWidget.add(
        EditableItem()
          ..type = ItemType.text
          ..text = editorNotifier.text.trim()
          ..backGroundColor = editorNotifier.backGroundColor
          // ..textColor = controlNotifier.colorList![editorNotifier.textColor]
          ..textColor = editorNotifier.backGroundColor == Colors.transparent
              ? controlNotifier.colorList![editorNotifier.textColor]
              : editorNotifier.backGroundColor == Colors.black
                  ? Colors.white
                  : 1 == 1
                      ? Colors.black
                      : controlNotifier.colorList![editorNotifier.textColor]
          ..fontFamily = editorNotifier.fontFamilyIndex
          ..fontSize = editorNotifier.textSize
          ..fontAnimationIndex = editorNotifier.fontAnimationIndex
          ..textAlign = editorNotifier.textAlign
          ..textList = editorNotifier.textList
          ..animationType = editorNotifier.animationList[editorNotifier.fontAnimationIndex]
          ..position = const Offset(0.0, 0.0),
      );
      editorNotifier.setDefaults();
      controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    } else {
      editorNotifier.setDefaults();
      controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    }
  }
}
