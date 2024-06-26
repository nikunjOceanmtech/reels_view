// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reels_view/global.dart';
import 'package:reels_view/sticker/src/domain/models/editable_items.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:reels_view/sticker/src/presentation/utils/constants/app_enums.dart';

Future<dynamic> stickerBottomSheet({
  required BuildContext context,
  required DraggableWidgetNotifier editableItem,
  required TextEditingNotifier editingProvider,
}) async {
  return await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black45,
    builder: (context) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: BottomSheetView(editableItem: editableItem, editingProvider: editingProvider),
      );
    },
  );
}

class BottomSheetView extends StatefulWidget {
  final DraggableWidgetNotifier editableItem;
  final TextEditingNotifier editingProvider;
  const BottomSheetView({
    super.key,
    required this.editableItem,
    required this.editingProvider,
  });

  @override
  State<BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<BottomSheetView> {
  @override
  Widget build(BuildContext context) {
    final List<String> systemEmojis = [
      "😀", "😃", "😄", "😁", "😆", "😅", // Smileys & Emotion
      "😂", "🤣", "😊", "😇", "🙂", "🙃",
      "😉", "😌", "😍", "🥰", "😘", "😗",
      "😙", "😚", "😋", "😛", "😝", "😜",
      "🤪", "🤨", "🧐", "🤓", "😎", "🤩",
      "🥳", "😏", "😒", "😞", "😔", "😟",
      "😕", "🙁", "😣", "😖", "😫", "😩",
      "🥺", "😢", "😭", "😤", "😠", "😡",
      "🤬", "🤯", "😳", "🥵", "🥶", "😱",
      "😨", "😰", "😥", "😓", "🤗", "🤔",
      "🤭", "🤫", "🤥", "😶", "😐", "😑",
      "😬", "🙄", "😯", "😦", "😧", "😮",
      "😲", "🥱", "😴", "🤤", "😪", "😵",
      "🤐", "🥴", "🤢", "🤮", "🤧", "😷",
      "🤒", "🤕", "🤑", "🤠", "😈", "👿",
      "👹", "👺", "🤡", "💩", "👻", "💀",
      "☠️", "👽", "👾", "🤖", "🎃", "😺",
      "😸", "😹", "😻", "😼", "😽", "🙀",
      "😿", "😾", "👐", "🙌", "👏", "🤝",
      "👍", "👎", "👊", "✊", "🤛", "🤜",
      "🤞", "✌️", "🤟", "🤘", "👌", "👈",
      "👉", "👆", "👇", "☝️", "✋", "🤚",
      "🖐", "🖖", "👋", "🤙", "💪", "🦾",
      "🦵", "🦿", "🦶", "👂", "🦻", "👃",
      "🧠", "🦷", "🦴", "👀", "👁️", "👅",
      "👄", "💋", "🩸", "👶", "🧒", "👦",
      "👧", "🧑", "👱", "👨", "🧔", "👨‍🦰",
      "👨‍🦱", "👨‍🦳", "👨‍🦲", "👩", "👩‍🦰", "👩‍🦱",
      "👩‍🦳", "👩‍🦲", "🧓", "👴", "👵", "🙍",
      "🙍‍♂️", "🙍‍♀️", "🙎", "🙎‍♂️", "🙎‍♀️", "🙅",
      "🙅‍♂️", "🙅‍♀️", "🙆", "🙆‍♂️", "🙆‍♀️", "💁",
      "💁‍♂️", "💁‍♀️", "🙋", "🙋‍♂️", "🙋‍♀️", "🧏",
      "🧏‍♂️", "🧏‍♀️", "🙇", "🙇‍♂️", "🙇‍♀️", "🤦",
      "🤦‍♂️", "🤦‍♀️", "🤷", "🤷‍♂️", "🤷‍♀️", "🧑‍⚕️",
      "👨‍⚕️", "👩‍⚕️", "🧑‍🎓", "👨‍🎓", "👩‍🎓", "🧑‍🏫",
      "👨‍🏫", "👩‍🏫", "🧑‍⚖️", "👨‍⚖️", "👩‍⚖️", "🧑‍🌾",
      "👨‍🌾", "👩‍🌾", "🧑‍🍳", "👨‍🍳", "👩‍🍳", "🧑‍🔧",
      "👨‍🔧", "👩‍🔧", "🧑‍🏭", "👨‍🏭", "👩‍🏭", "🧑‍💼",
      "👨‍💼", "👩‍💼", "🧑‍🔬", "👨‍🔬", "👩‍🔬", "🧑‍💻",
      "👨‍💻", "👩‍💻", "🧑‍🎤", "👨‍🎤", "👩‍🎤", "🧑‍🎨",
      "👨‍🎨", "👩‍🎨", "🧑‍✈️", "👨‍✈️", "👩‍✈️", "🧑‍🚀",
      "👨‍🚀", "👩‍🚀", "🧑‍🚒", "👨‍🚒", "👩‍🚒", "👮",
      "👮‍♂️", "👮‍♀️", "🕵️", "🕵️‍♂️", "🕵️‍♀️", "💂",
      "💂‍♂️", "💂‍♀️", "👷", "👷‍♂️", "👷‍♀️", "🤴",
      "👸", "👳", "👳‍♂️", "👳‍♀️", "👲", "🧕",
      "🤵", "🤵‍♂️", "🤵‍♀️", "👰", "👰‍♂️", "👰‍♀️",
      "🤰", "🤱", "👩‍🍼", "👨‍🍼", "🧑‍🍼", "👼",
      "🎅", "🤶", "🦸", "🦸‍♂️", "🦸‍♀️", "🦹",
      "🦹‍♂️", "🦹‍♀️", "🧙", "🧙‍♂️", "🧙‍♀️", "🧚",
      "🧚‍♂️", "🧚‍♀️", "🧛", "🧛‍♂️", "🧛‍♀️", "🧜",
      "🧜‍♂️", "🧜‍♀️", "🧝", "🧝‍♂️", "🧝‍♀️", "🧞",
      "🧞‍♂️", "🧞‍♀️", "🧟", "🧟‍♂️", "🧟‍♀️", "💆",
      "💆‍♂️", "💆‍♀️", "💇", "💇‍♂️", "💇‍♀️", "🚶",
      "🚶‍♂️", "🚶‍♀️", "🧍", "🧍‍♂️", "🧍‍♀️", "🧎",
      "🧎‍♂️", "🧎‍♀️", "🧑‍🦯", "👨‍🦯", "👩‍🦯", "🧑‍🦼",
      "👨‍🦼", "👩‍🦼", "🧑‍🦽", "👨‍🦽", "👩‍🦽", "🏃",
      "🏃‍♂️", "🏃‍♀️", "💃", "🕺", "🕴️", "👯",
      "👯‍♂️", "👯‍♀️", "🧖", "🧖‍♂️", "🧖‍♀️", "🧘",
      "🧑‍🤝‍🧑", "👭", "👫", "👬", "💏", "👩‍❤️‍💋‍👨",
      "👨‍❤️‍💋‍👨", "👩‍❤️‍💋‍👩", "💑", "👩‍❤️‍👨", "👨‍❤️‍👨", "👩‍❤️‍👩",
      "👪", "👨‍👩‍👦", "👨‍👩‍👧", "👨‍👩‍👧‍👦", "👨‍👩‍👦‍👦", "👨‍👩‍👧‍👧",
      "👨‍👨‍👦", "👨‍👨‍👧", "👨‍👨‍👧‍👦", "👨‍👨‍👦‍👦", "👨‍👨‍👧‍👧", "👩‍👩‍👦",
      "👩‍👩‍👧", "👩‍👩‍👧‍👦", "👩‍👩‍👦‍👦", "👩‍👩‍👧‍👧", "👨‍👦", "👨‍👦‍👦",
      "👨‍👧", "👨‍👧‍👦", "👨‍👧‍👧", "👩‍👦", "👩‍👦‍👦", "👩‍👧",
      "👩‍👧‍👦", "👩‍👧‍👧", "🗣️", "👤", "👥", "🫂",
    ];

    return Column(
      children: [
        SizedBox(height: 20),
        InkWell(
          onTap: () async {
            String? imagePath = await pickImage();
            if (imagePath != null) {
              Navigator.pop(context);
              widget.editableItem.draggableWidget.add(
                EditableItem()
                  ..type = ItemType.gif
                  ..child = imageBuilder(imageUrl: imagePath)
                  ..position = const Offset(0.0, 0.0),
              );
              widget.editableItem.update();
            }
          },
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageBuilder(
                    imageUrl: "assets/shorts/gallery.svg",
                    color: primary1Color,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Photo",
                    style: TextStyle(fontSize: 22.sp, color: primary1Color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: systemEmojis.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  widget.editableItem.draggableWidget.add(
                    EditableItem()
                      ..type = ItemType.text
                      ..text = systemEmojis[index]
                      ..backGroundColor = widget.editingProvider.backGroundColor
                      ..fontSize = 1 == 1 ? 70 : widget.editingProvider.textSize
                      ..fontAnimationIndex = widget.editingProvider.fontAnimationIndex
                      ..textAlign = widget.editingProvider.textAlign
                      ..textList = widget.editingProvider.textList
                      ..animationType = widget.editingProvider.animationList[widget.editingProvider.fontAnimationIndex]
                      ..position = const Offset(0.0, 0.0)
                      ..isEmoji = true,
                  );
                  widget.editableItem.update();
                },
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Text(
                    textAlign: TextAlign.center,
                    systemEmojis[index],
                    style: TextStyle(fontSize: 50.sp),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<String?> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      var pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return pickedFile.path;
      }
    } catch (e) {
      // return CustomSnackbar.show(snackbarType: SnackbarType.ERROR, message: e.toString());
    }
    return null;
  }
}

Color primary1Color = Color(0xff084277);
Color secondary1Color = Color(0xff4392F1);
Color neutral1Color = Color(0xff084277);
