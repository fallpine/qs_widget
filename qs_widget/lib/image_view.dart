import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qs_widget/box.dart';

enum ImageType {
  asset, // 本地资源,
  svg, // svg图片
  network, // 网络资源,
  file, // 图片文件
}

class ImageView extends StatelessWidget {
  /// Func
  const ImageView({
    super.key,
    required this.type,
    required this.imageSrc,
    this.fit = BoxFit.cover,
    this.imageColor,
    this.placeholder,
    this.error,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.isCircle = false,
    this.radius,
    this.border,
    this.boxShadows,
    this.gradient,
    this.constraints,
    this.centerSlice,
  });

  /// Property
  final ImageType type;
  final String imageSrc;
  final BoxFit fit;
  final Color? imageColor;
  final Widget? placeholder;
  final Widget? error;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool isCircle;
  final BorderRadius? radius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadows;
  final Gradient? gradient;
  final BoxConstraints? constraints;
  // 拉伸区域，配合fit: BoxFit.fill使用
  final Rect? centerSlice;

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Box(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      isCircle: isCircle,
      radius: radius,
      border: border,
      boxShadows: boxShadows,
      gradient: gradient,
      constraints: constraints,
      child: Builder(
        builder: (context) {
          switch (type) {
            case ImageType.asset:
              return Image.asset(
                imageSrc,
                width: width,
                height: height,
                fit: fit,
                color: imageColor,
                centerSlice: centerSlice,
                errorBuilder: (context, error, stackTrace) {
                  return this.error == null ? SizedBox.shrink() : this.error!;
                },
              );

            case ImageType.svg:
              return SvgPicture.asset(
                imageSrc,
                width: width,
                height: height,
                fit: fit,
                colorFilter: imageColor == null
                    ? null
                    : ColorFilter.mode(imageColor!, BlendMode.srcIn),
                errorBuilder: (context, error, stackTrace) {
                  return this.error == null ? const SizedBox.shrink() : this.error!;
                },
              );

            case ImageType.network:
              return CachedNetworkImage(
                imageUrl: imageSrc,
                fit: fit,
                color: imageColor,
                placeholder: placeholder == null ? null : (context, url) => placeholder!,
                errorWidget: (context, url, error) =>
                    (this.error == null ? const SizedBox.shrink() : this.error!),
              );

            case ImageType.file:
              return Image.file(
                File(imageSrc),
                width: width,
                height: height,
                fit: fit,
                color: imageColor,
                centerSlice: centerSlice,
                errorBuilder: (context, error, stackTrace) {
                  return this.error == null ? const SizedBox.shrink() : this.error!;
                },
              );
          }
        },
      ),
    );
  }
}
