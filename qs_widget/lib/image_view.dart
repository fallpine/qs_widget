import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qs_widget/box.dart';

/// 图片资源类型。
enum ImageType {
  /// Flutter 资源目录中的位图。
  asset,

  /// Flutter 资源目录中的 SVG 图片。
  svg,

  /// 通过网络地址加载的图片。
  network,

  /// 设备本地文件系统中的图片。
  file,
}

/// 统一加载资源图片、SVG、网络图片和本地文件图片的组件。
class ImageView extends StatelessWidget {
  /// 创建一个图片组件。
  ///
  /// [type] 指定图片来源类型，[imageSrc] 为对应的资源路径、网络地址或文件路径。
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
    this.isClipsToBounds = true,
    this.outerRadius,
    this.innerRadius,
    this.border,
    this.boxShadows,
    this.gradient,
    this.constraints,
    this.centerSlice,
  });

  /// 图片资源类型。
  final ImageType type;

  /// 图片资源路径、网络地址或本地文件路径。
  final String imageSrc;

  /// 图片在可用空间内的填充方式。
  final BoxFit fit;

  /// 叠加到图片上的颜色。
  final Color? imageColor;

  /// 网络图片加载期间显示的占位组件。
  final Widget? placeholder;

  /// 图片加载失败时显示的组件。
  final Widget? error;

  /// 图片容器宽度。
  final double? width;

  /// 图片容器高度。
  final double? height;

  /// 图片容器内边距。
  final EdgeInsetsGeometry? padding;

  /// 图片容器外边距。
  final EdgeInsetsGeometry? margin;

  /// 图片容器背景颜色。
  final Color? backgroundColor;

  /// 是否使用圆形外观。
  final bool isCircle;

  /// 是否裁剪超出图片容器边界的内容。
  final bool isClipsToBounds;

  /// 图片容器外层装饰圆角。
  final BorderRadius? outerRadius;

  /// 图片内容的裁剪圆角。
  final BorderRadius? innerRadius;

  /// 图片容器边框。
  final BoxBorder? border;

  /// 图片容器阴影列表。
  final List<BoxShadow>? boxShadows;

  /// 图片容器背景渐变。
  final Gradient? gradient;

  /// 图片容器的额外尺寸约束。
  final BoxConstraints? constraints;

  /// 图片的九宫格拉伸区域，通常与 `fit: BoxFit.fill` 配合使用。
  final Rect? centerSlice;

  @override
  Widget build(BuildContext context) {
    return Box(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      isCircle: isCircle,
      isClipsToBounds: isClipsToBounds,
      outerRadius: outerRadius,
      innerRadius: innerRadius,
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
                  return this.error == null
                      ? const SizedBox.shrink()
                      : this.error!;
                },
              );

            case ImageType.network:
              return CachedNetworkImage(
                imageUrl: imageSrc,
                fit: fit,
                color: imageColor,
                placeholder: placeholder == null
                    ? null
                    : (context, url) => placeholder!,
                errorWidget: (context, url, error) => (this.error == null
                    ? const SizedBox.shrink()
                    : this.error!),
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
                  return this.error == null
                      ? const SizedBox.shrink()
                      : this.error!;
                },
              );
          }
        },
      ),
    );
  }
}
