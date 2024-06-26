// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/control_provider.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:reels_view/sticker/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:reels_view/sticker/src/presentation/reels_sticker_editor/reels_sticker_editor.dart';
import 'package:reels_view/sticker/src/presentation/utils/modal_sheets.dart';
import 'package:reels_view/sticker/src/presentation/widgets/sticker_bottom_sheet.dart';

class TopTools extends StatefulWidget {
  final GlobalKey contentKey;
  final BuildContext context;
  final void Function() onMusicTap;
  final void Function() onEffectTap;
  final void Function() onFilterDoneTap;
  final void Function() onFilterCancelTap;
  final void Function(String imagePath) onDownloadTap;
  final bool isShowFilterIcon;
  final TextEditingNotifier editingProvider;

  const TopTools({
    super.key,
    required this.contentKey,
    required this.context,
    required this.onMusicTap,
    required this.onEffectTap,
    required this.onDownloadTap,
    required this.isShowFilterIcon,
    required this.onFilterCancelTap,
    required this.onFilterDoneTap,
    required this.editingProvider,
  });

  @override
  TopToolsState createState() => TopToolsState();
}

class TopToolsState extends State<TopTools> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ControlNotifier, PaintingNotifier, DraggableWidgetNotifier>(
      builder: (_, controlNotifier, paintingNotifier, itemNotifier, __) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: widget.isShowFilterIcon
                ? filterIconView(context: context)
                : normalIconView(
                    context: context,
                    controlNotifier: controlNotifier,
                    itemNotifier: itemNotifier,
                    editingProvider: widget.editingProvider,
                  ),
          ),
        );
      },
    );
  }

  Widget filterIconView({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        commonIconView(
          imageUrl: "assets/shorts/cross_arrow.png",
          onTap: widget.onFilterCancelTap,
        ),
        commonIconView(
          imageUrl: "assets/shorts/right_tick.png",
          onTap: widget.onFilterDoneTap,
        ),
      ],
    );
  }

  Widget normalIconView({
    required ControlNotifier controlNotifier,
    required BuildContext context,
    required DraggableWidgetNotifier itemNotifier,
    required TextEditingNotifier editingProvider,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        commonIconView(
          imageUrl: "assets/shorts/back_arrow.png",
          onTap: () async {
            bool isCheck = await popScope();
            if (isCheck) {
              Navigator.pop(context, false);
            }
          },
        ),
        Row(
          children: [
            commonIconView(
              imageUrl: "assets/shorts/music.png",
              onTap: widget.onMusicTap,
            ),
            const SizedBox(width: 10),
            commonIconView(
              imageUrl: "assets/shorts/text_aa.png",
              onTap: () => controlNotifier.isTextEditing = !controlNotifier.isTextEditing,
            ),
            const SizedBox(width: 10),
            commonIconView(
              imageUrl: "assets/shorts/sticker.png",
              onTap: () async {
                await stickerBottomSheet(
                  context: context,
                  editableItem: itemNotifier,
                  editingProvider: editingProvider,
                );
              },
            ),
            const SizedBox(width: 10),
            commonIconView(
              imageUrl: "assets/shorts/effect.png",
              onTap: widget.onEffectTap,
            ),
            const SizedBox(width: 10),
            commonIconView(
              imageUrl: "assets/shorts/download.png",
              onTap: () async {
                if (itemNotifier.draggableWidget.isEmpty) {
                  widget.onDownloadTap("");
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
                    widget.onDownloadTap(imagePath);
                  } else {
                    widget.onDownloadTap("");
                  }
                }
              },
            ),
          ],
        ),
      ],
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
      return exitDialog(context: context);
    }
    return false;
  }

  Widget commonIconView({
    required String imageUrl,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Image(image: AssetImage(imageUrl), height: 40.h, width: 40.w),
    );
  }
}
