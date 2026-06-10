import 'package:flutter/material.dart';

/// 提供尺寸、间距、背景、边框、圆角和裁剪能力的容器组件。
class Box extends StatelessWidget {
  /// 创建一个通用容器。
  ///
  /// [outerRadius] 用于外层装饰圆角，[innerRadius] 用于子组件裁剪圆角；
  /// 当 [isCircle] 为 `true` 时，组件以圆形样式显示。
  const Box({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.isCircle = false,
    this.outerRadius,
    this.innerRadius,
    this.border,
    this.boxShadows,
    this.gradient,
    this.constraints,
    this.clipBehavior = Clip.hardEdge,
    this.isClipsToBounds = true,
    this.child,
  });

  /// 容器宽度。
  final double? width;

  /// 容器高度。
  final double? height;

  /// 容器内边距。
  final EdgeInsetsGeometry? padding;

  /// 容器外边距。
  final EdgeInsetsGeometry? margin;

  /// 容器背景颜色。
  final Color? color;

  /// 是否使用圆形外观。
  final bool isCircle;

  /// 外层装饰圆角。
  final BorderRadius? outerRadius;

  /// 子组件的裁剪圆角，主要用于图片等内容。
  final BorderRadius? innerRadius;

  /// 容器边框。
  final BoxBorder? border;

  /// 容器阴影列表。
  final List<BoxShadow>? boxShadows;

  /// 容器背景渐变。
  final Gradient? gradient;

  /// 容器的额外尺寸约束。
  final BoxConstraints? constraints;

  /// 容器自身的裁剪方式。
  final Clip clipBehavior;

  /// 是否裁剪超出边界的子组件。
  final bool isClipsToBounds;

  /// 容器中显示的子组件。
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        color: color,
        borderRadius: isCircle ? null : outerRadius ?? innerRadius,
        border: border,
        boxShadow: boxShadows,
        gradient: gradient,
      ),
      constraints: constraints,
      clipBehavior: clipBehavior, // 设置Clip行为
      child: isClipsToBounds
          ? isCircle
                ? ClipOval(child: child)
                : ClipRRect(
                    borderRadius:
                        innerRadius ?? outerRadius ?? BorderRadius.zero,
                    child: child,
                  )
          : child,
    );
  }
}
