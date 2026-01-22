import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  /// Func
  const Box({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.isCircle = false,
    this.radius,
    this.border,
    this.boxShadows,
    this.gradient,
    this.constraints,
    this.clipBehavior = Clip.hardEdge,
    this.child,
  });

  /// Property
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool isCircle;
  final BorderRadius? radius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadows;
  final Gradient? gradient;
  final BoxConstraints? constraints;
  final Clip clipBehavior;
  final Widget? child;

  /// Widget
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
        borderRadius: isCircle ? null : radius,
        border: border,
        boxShadow: boxShadows,
        gradient: gradient,
      ),
      constraints: constraints,
      clipBehavior: clipBehavior, // 设置Clip行为
      child: child,
    );
  }
}
