import 'package:flutter/material.dart';
import 'package:qs_widget/box.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.normalBackgroundColor,
    this.selectedBackgroundColor,
    this.disabledBackgroundColor,
    this.isCircle = false,
    this.isClipsToBounds = true,
    this.outerRadius,
    this.innerRadius,
    this.border,
    this.boxShadows,
    this.gradient,
    this.constraints,
    this.isSelected = false,
    this.isEnabled = true,
    this.normalChild,
    this.selectedChild,
    this.disabledChild,
    this.onTap,
  });

  // 基础属性
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  // 样式相关
  final Color? normalBackgroundColor;
  final Color? selectedBackgroundColor;
  final Color? disabledBackgroundColor;
  final bool isCircle;
  final bool isClipsToBounds;
  final BorderRadius? outerRadius;
  final BorderRadius? innerRadius; // 主要用于图片设置圆角
  final BoxBorder? border;
  final List<BoxShadow>? boxShadows;
  final Gradient? gradient;
  final BoxConstraints? constraints;

  // 选中状态
  final bool isSelected;
  // 禁用状态
  final bool isEnabled;

  // child
  final Widget? normalChild;
  final Widget? selectedChild;
  final Widget? disabledChild;

  // 点击回调
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Box(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: isEnabled
          ? (isSelected
                ? (selectedBackgroundColor ?? normalBackgroundColor)
                : normalBackgroundColor)
          : disabledBackgroundColor ?? normalBackgroundColor,
      isCircle: isCircle,
      isClipsToBounds: isClipsToBounds,
      outerRadius: outerRadius,
      innerRadius: innerRadius,
      border: border,
      boxShadows: boxShadows,
      gradient: gradient,
      constraints: constraints,
      child: ElevatedButton(
        onPressed: isEnabled ? onTap : null,
        style: kBaseButtonStyle,
        child: isEnabled
            ? (isSelected ? (selectedChild ?? normalChild) : normalChild)
            : disabledChild ?? normalChild,
      ),
    );
  }
}

ButtonStyle kBaseButtonStyle = ButtonStyle(
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  minimumSize: WidgetStateProperty.all(Size.zero),
  padding: WidgetStateProperty.all(EdgeInsets.zero),
  shadowColor: WidgetStateProperty.all(Colors.transparent),
  elevation: WidgetStateProperty.all(0),
  splashFactory: NoSplash.splashFactory,
  overlayColor: WidgetStateProperty.all(Colors.transparent),
  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
  backgroundColor: WidgetStateProperty.all(Colors.transparent),
);
