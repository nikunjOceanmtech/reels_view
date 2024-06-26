// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget imageBuilder({
  required String imageUrl,
  double? height,
  double? width,
  double? borderRadius,
  int? cacheWidth,
  BoxFit? fit,
  Color? color,
  bool? isBorderOnlySide,
  Radius? bottomLeft,
  Radius? bottomRight,
  Radius? topLeft,
  Radius? topRight,
  EdgeInsets? padding,
  double? horizontalPadding,
  double? verticalPadding,
  bool? isHideLoading,
}) {
  if (imageUrl.isEmpty) {
    return Center(child: warningIcon(color: color));
  } else if (imageUrl.startsWith('https')) {
    if (imageUrl.endsWith('svg')) {
      return ClipRRect(
        borderRadius: isBorderOnlySide == true
            ? BorderRadius.only(
                bottomLeft: bottomLeft ?? Radius.zero,
                bottomRight: bottomRight ?? Radius.zero,
                topLeft: topLeft ?? Radius.zero,
                topRight: topRight ?? Radius.zero,
              )
            : BorderRadius.circular(borderRadius ?? 0),
        child: SvgPicture.network(
          imageUrl,
          fit: fit ?? BoxFit.fitWidth,
          width: width,
          height: height,
          colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: isBorderOnlySide == true
            ? BorderRadius.only(
                bottomLeft: bottomLeft ?? Radius.zero,
                bottomRight: bottomRight ?? Radius.zero,
                topLeft: topLeft ?? Radius.zero,
                topRight: topRight ?? Radius.zero,
              )
            : BorderRadius.circular(borderRadius ?? 0),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: fit ?? BoxFit.cover,
          memCacheWidth: cacheWidth,
          color: color,
          height: height,
          width: width,
          errorListener: (value) => warningIcon(
            color: color,
            bgColor: Colors.grey.withOpacity(0.15),
          ),
          placeholder: (context, url) => Visibility(
            visible: !(isHideLoading ?? false),
            child: SizedBox(
              height: height,
              width: width,
              child: loadingIos(),
            ),
          ),
          errorWidget: (context, error, stackTrace) => warningIcon(
            color: color,
            bgColor: Colors.grey.withOpacity(0.15),
          ),
        ),
      );
    }
  } else if (imageUrl.startsWith('assets') && imageUrl.endsWith('.svg')) {
    return SvgPicture.asset(
      imageUrl,
      fit: fit ?? BoxFit.fitWidth,
      width: width,
      height: height,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  } else if (imageUrl.startsWith('assets')) {
    return Image.asset(
      imageUrl,
      fit: fit ?? BoxFit.fitWidth,
      width: width,
      height: height,
      color: color,
      cacheWidth: cacheWidth,
      errorBuilder: (context, error, stackTrace) => warningIcon(color: color),
    );
  } else {
    return Image.file(
      File(imageUrl),
      fit: fit ?? BoxFit.fitWidth,
      width: width,
      height: height,
      color: color,
      cacheWidth: cacheWidth,
      errorBuilder: (context, error, stackTrace) => warningIcon(color: color),
    );
  }
}

Widget warningIcon({double? width, double? height, Color? color, Alignment? alignment, Color? bgColor}) {
  return Container(
    color: bgColor,
    child: Center(
      child: SvgPicture.asset(
        AppImages.svg_warning,
        width: width ?? 32.w,
        height: height ?? 32.h,
        colorFilter: ColorFilter.mode(primary1Color, BlendMode.srcIn),
        alignment: alignment ?? Alignment.center,
      ),
    ),
  );
}

Widget loadingIos() {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(16.r),
      child: SizedBox(
        height: 300,
        width: 300,
        child: Center(
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.red,
              strokeWidth: 2,
              backgroundColor: primary1Color,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      ),
    ),
  );
}

class AppImages {
  static const svg_warning = 'assets/warning.svg';
}

Color primary1Color = Color(0xff084277);
Color secondary1Color = Color(0xff4392F1);
Color neutral1Color = Color(0xff293847);
