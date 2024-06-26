import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/control_provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:reels_view/sticker/src/presentation/widgets/animated_onTap_button.dart';

class FontSelector extends StatelessWidget {
  const FontSelector({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer2<TextEditingNotifier, ControlNotifier>(
      builder: (context, editorNotifier, controlNotifier, child) {
        return Container(
          height: size.height * 0.065,
          width: size.width,
          alignment: Alignment.center,
          child: PageView.builder(
            controller: editorNotifier.fontFamilyController,
            itemCount: controlNotifier.fontList!.length,
            onPageChanged: (index) {
              editorNotifier.fontFamilyIndex = index;
              HapticFeedback.heavyImpact();
            },
            physics: const BouncingScrollPhysics(),
            allowImplicitScrolling: true,
            pageSnapping: false,
            itemBuilder: (context, index) {
              return AnimatedOnTapButton(
                onTap: () {
                  editorNotifier.fontFamilyIndex = index;
                  editorNotifier.fontFamilyController.jumpToPage(index);
                  editorNotifier.update();
                },
                child: Container(
                  width: size.height * 0.065,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    color: index == editorNotifier.fontFamilyIndex ? Colors.white : Colors.black.withOpacity(0.4),
                    border: Border.all(
                      color: index == editorNotifier.fontFamilyIndex ? Colors.white : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      'Aa',
                      style: TextStyle(
                        fontFamily: controlNotifier.fontList![index],
                        color: index == editorNotifier.fontFamilyIndex ? Colors.red : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
