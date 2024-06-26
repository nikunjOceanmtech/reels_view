import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reels_view/global.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:reels_view/sticker/src/presentation/widgets/tool_button.dart';

class TopTextTools extends StatelessWidget {
  final void Function() onDone;

  const TopTextTools({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Consumer<TextEditingNotifier>(
      builder: (context, editorNotifier, child) {
        return Container(
          padding: const EdgeInsets.only(top: 15),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ToolButton(
                    onTap: () {
                      editorNotifier.isFontFamily = !editorNotifier.isFontFamily;
                      editorNotifier.isTextAnimation = false;
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          if (editorNotifier.fontFamilyController.hasClients) {
                            editorNotifier.fontFamilyController.animateToPage(
                              editorNotifier.fontFamilyIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      );
                    },
                    child: Transform.scale(
                      scale: !editorNotifier.isFontFamily ? 0.8 : 1.3,
                      child: imageBuilder(
                        imageUrl: !editorNotifier.isFontFamily
                            ? 'assets/shorts/text_aa.png'
                            : 'assets/shorts/circular_gradient.png',
                      ),
                    ),
                  ),
                  ToolButton(
                    onTap: editorNotifier.onAlignmentChange,
                    child: Transform.scale(
                      scale: 0.8,
                      child: Icon(
                        editorNotifier.textAlign == TextAlign.center
                            ? Icons.format_align_center
                            : editorNotifier.textAlign == TextAlign.right
                                ? Icons.format_align_right
                                : Icons.format_align_left,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ToolButton(
                    onTap: editorNotifier.onBackGroundChange,
                    child: Transform.scale(
                      scale: 0.7,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, bottom: 3),
                          child: imageBuilder(imageUrl: 'assets/shorts/font_backGround.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onDone,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 10,
                      top: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 1.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
