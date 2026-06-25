import 'package:flutter/material.dart';
import 'package:qs_widget/box.dart';

/// 支持普通、选中和禁用状态的按钮组件。
class Button extends StatelessWidget {
  /// 创建一个多状态按钮。
  ///
  /// [normalChild]、[selectedChild] 和 [disabledChild] 分别对应不同状态的内容；
  /// [onTap] 仅在 [isEnabled] 为 `true` 时触发。
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

  /// 按钮宽度。
  final double? width;

  /// 按钮高度。
  final double? height;

  /// 按钮内边距。
  final EdgeInsetsGeometry? padding;

  /// 按钮外边距。
  final EdgeInsetsGeometry? margin;

  /// 普通状态下的背景颜色。
  final Color? normalBackgroundColor;

  /// 选中状态下的背景颜色。
  final Color? selectedBackgroundColor;

  /// 禁用状态下的背景颜色。
  final Color? disabledBackgroundColor;

  /// 是否使用圆形外观。
  final bool isCircle;

  /// 是否裁剪超出按钮边界的内容。
  final bool isClipsToBounds;

  /// 按钮外层装饰圆角。
  final BorderRadiusGeometry? outerRadius;

  /// 按钮内容的裁剪圆角，主要用于图片等内容。
  final BorderRadiusGeometry? innerRadius;

  /// 按钮边框。
  final BoxBorder? border;

  /// 按钮阴影列表。
  final List<BoxShadow>? boxShadows;

  /// 按钮背景渐变。
  final Gradient? gradient;

  /// 按钮的额外尺寸约束。
  final BoxConstraints? constraints;

  /// 按钮当前是否处于选中状态。
  final bool isSelected;

  /// 按钮当前是否可用。
  final bool isEnabled;

  /// 普通状态下显示的子组件。
  final Widget? normalChild;

  /// 选中状态下显示的子组件，未设置时使用 [normalChild]。
  final Widget? selectedChild;

  /// 禁用状态下显示的子组件，未设置时使用 [normalChild]。
  final Widget? disabledChild;

  /// 按钮点击回调。
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

/// [Button] 内部使用的透明基础按钮样式。
ButtonStyle kBaseButtonStyle = ButtonStyle(
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  minimumSize: WidgetStateProperty.all(Size.zero),
  padding: WidgetStateProperty.all(EdgeInsets.zero),
  shadowColor: WidgetStateProperty.all(Colors.transparent),
  elevation: WidgetStateProperty.all(0),
  splashFactory: NoSplash.splashFactory,
  overlayColor: WidgetStateProperty.all(Colors.transparent),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
  ),
  backgroundColor: WidgetStateProperty.all(Colors.transparent),
);
