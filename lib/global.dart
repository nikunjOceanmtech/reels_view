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

class FilterList {
  List filters = [
    FilterModel(path: "", name: ""),
    FilterModel(path: "assets/short_filter_images/effect1.png", name: "Filter 1"),
    FilterModel(path: "assets/short_filter_images/effect2.png", name: "Filter 2"),
    FilterModel(path: "assets/short_filter_images/effect3.png", name: "Filter 3"),
    FilterModel(path: "assets/short_filter_images/effect4.png", name: "Filter 4"),
    FilterModel(path: "assets/short_filter_images/red.png", name: "Filter 6"),
    FilterModel(path: "assets/short_filter_images/pink.png", name: "Filter 7"),
    FilterModel(path: "assets/short_filter_images/purple.png", name: "Filter 8"),
    FilterModel(path: "assets/short_filter_images/deepPurple.png", name: "Filter 9"),
    FilterModel(path: "assets/short_filter_images/indigo.png", name: "Filter 10"),
    FilterModel(path: "assets/short_filter_images/blue.png", name: "Filter 11"),
    FilterModel(path: "assets/short_filter_images/lightBlue.png", name: "Filter 12"),
    FilterModel(path: "assets/short_filter_images/cyan.png", name: "Filter 13"),
    FilterModel(path: "assets/short_filter_images/teal.png", name: "Filter 14"),
    FilterModel(path: "assets/short_filter_images/green.png", name: "Filter 15"),
    FilterModel(path: "assets/short_filter_images/lightGreen.png", name: "Filter 16"),
    FilterModel(path: "assets/short_filter_images/lime.png", name: "Filter 17"),
    FilterModel(path: "assets/short_filter_images/yellow.png", name: "Filter 18"),
    FilterModel(path: "assets/short_filter_images/amber.png", name: "Filter 19"),
    FilterModel(path: "assets/short_filter_images/orange.png", name: "Filter 20"),
    FilterModel(path: "assets/short_filter_images/deepOrange.png", name: "Filter 21"),
    FilterModel(path: "assets/short_filter_images/brown.png", name: "Filter 22"),
    FilterModel(path: "assets/short_filter_images/blueGrey.png", name: "Filter 23"),
  ];
}

class FilterModel {
  final String path;
  final String name;

  FilterModel({required this.path, required this.name});

  FilterModel copyWith({
    String? path,
    String? name,
  }) {
    return FilterModel(
      path: path ?? this.path,
      name: name ?? this.name,
    );
  }
}
