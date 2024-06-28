import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reels_view/sticker/src/presentation/widgets/sticker_bottom_sheet.dart';

Future<bool> exitDialog({required BuildContext context}) async {
  return await showAlertDialog(
        context: context,
        isTitle: true,
        titleText: "Discard Changes",
        titleTextStyle: TextStyle(color: primary1Color),
        contentTextStyle: TextStyle(color: neutral1Color),
        text: "Changes will not be saved. Do you\nwant to proceed?",
        textColor: Colors.black,
        onNegativeCallback: () => Navigator.pop(context, false),
        onPositiveCallback: () {
          Navigator.pop(context, true);
        },
      ) ??
      false;
}

Future<dynamic> showAlertDialog({
  required BuildContext context,
  VoidCallback? onPositiveCallback,
  String? text,
  String? titleText,
  Color? textColor,
  bool isTitle = false,
  VoidCallback? onNegativeCallback,
  List<Widget>? actions,
  TextStyle? titleTextStyle,
  TextStyle? contentTextStyle,
  Widget? titleWidget,
  Color? yesButtonTextColor,
  Color? yesButtonBgColor,
  Color? noButtonBgColor,
  Color? noButtonTextColor,
  EdgeInsets? insetPadding,
  EdgeInsetsGeometry? titlePadding,
}) async {
  var data = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: insetPadding ?? EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.r))),
        actionsPadding: EdgeInsets.zero,
        titlePadding: titlePadding ?? EdgeInsets.zero,
        title: titleWidget ??
            SizedBox(
              width: ScreenUtil().screenWidth * 0.9,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  isTitle
                      ? Column(
                          children: [
                            Center(
                              child: commonText(
                                lineThrough: true,
                                style: titleTextStyle ?? TextStyle(color: neutral1Color, height: 1),
                                text: titleText ?? '',
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        )
                      : const SizedBox.shrink(),
                  Container(
                    child: commonText(
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      text: text ?? '',
                      style: contentTextStyle ?? TextStyle(color: primary1Color),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Row(
                      children: [
                        Expanded(
                          child: commonButton(
                            context: context,
                            borderRadius: 10.r,
                            onTap: onNegativeCallback ?? () => Navigator.pop(context),
                            alignment: Alignment.center,
                            text: "No",
                            textColor: noButtonTextColor ?? primary1Color,
                            color: noButtonBgColor ?? secondary1Color.withOpacity(0.20),
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: commonButton(
                            context: context,
                            borderRadius: 10.r,
                            onTap: onPositiveCallback ?? () {},
                            alignment: Alignment.center,
                            text: "Yes",
                            textColor: yesButtonTextColor ?? Colors.white,
                            color: yesButtonBgColor ?? primary1Color,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
      );
    },
  );
  return data;
}

Widget commonButton({
  String? text,
  required BuildContext context,
  required VoidCallback onTap,
  Color? textColor,
  double? borderRadius,
  double? width,
  Color? color,
  EdgeInsets? padding,
  double? height,
  TextStyle? style,
  bool? isBorder = false,
  Color? borderColor,
  double? borderWidth,
  AlignmentGeometry? alignment,
  double? marginAllSide,
  double? topLeft,
  double? topRight,
  double? bottomLeft,
  double? bottomRight,
  bool? isBorderOnlySide,
  bool? isMarginAllSide = true,
  EdgeInsetsGeometry? margin,
  double? paddingAllSide,
  bool? ispaddingAllSide = false,
  Widget? child,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      margin: margin,
      alignment: alignment ?? Alignment.center,
      color: color ?? primary1Color,
      padding: padding,
      child: child ??
          commonText(
            text: text ?? '',
            style: style ?? TextStyle(color: textColor ?? Colors.white),
          ),
    ),
  );
}

Widget commonText({
  required String text,
  bool? bold = false,
  FontWeight? fontWeight,
  TextOverflow? textOverflow,
  Color? color,
  double? fontSize,
  double? letterSpacing,
  double? wordSpacing,
  bool? fontFamily,
  TextAlign? textAlign,
  int? maxLines,
  bool? lineThrough,
  Color? lineThroughColor,
  double? lineThroughthickness,
  bool? underline,
  TextStyle? style,
  double? height,
}) {
  return Text(
    text,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    textAlign: textAlign,
    maxLines: maxLines,
    style: style ??
        TextStyle(
          height: height,
          color: color ?? neutral1Color,
          fontSize: fontSize?.sp ?? 20.sp,
          fontWeight: bold == true ? FontWeight.bold : fontWeight,
          fontFamily: fontFamily == false ? null : 'Poppins',
          letterSpacing: letterSpacing ?? 0.15,
          wordSpacing: wordSpacing ?? 0.1,
          decoration: lineThrough == true
              ? TextDecoration.lineThrough
              : underline == true
                  ? TextDecoration.underline
                  : TextDecoration.none,
          decorationColor: lineThroughColor ?? Colors.black38,
          decorationThickness: lineThroughthickness ?? 1.sp,
        ),
  );
}
