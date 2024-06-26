import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/control_provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:reels_view/sticker/src/presentation/widgets/animated_onTap_button.dart';

class ColorSelector extends StatelessWidget {
  const ColorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ControlNotifier, TextEditingNotifier, PaintingNotifier>(
      builder: (context, controlProvider, editorProvider, paintingProvider, child) {
        return Container(
          height: MediaQuery.of(context).size.width * 0.1,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: controlProvider.isPainting
                        ? controlProvider.colorList![paintingProvider.lineColor]
                        : controlProvider.colorList![editorProvider.textColor],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5)),
                child: ImageIcon(
                  const AssetImage('assets/shorts_asstes/icons/pickColor.png'),
                  color: controlProvider.isPainting
                      ? (paintingProvider.lineColor == 0 ? Colors.black : Colors.white)
                      : (editorProvider.textColor == 0 ? Colors.black : Colors.white),
                  size: 20,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...controlProvider.colorList!.map((color) {
                        final int index = controlProvider.colorList!.indexOf(color);
                        return AnimatedOnTapButton(
                          onTap: () {
                            if (controlProvider.isPainting) {
                              paintingProvider.lineColor = index;
                            } else {
                              editorProvider.textColor = index;
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: controlProvider.colorList![index],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                    ],
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
