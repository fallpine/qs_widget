import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// 用于显示普通文本或自动缩放文本的标签组件。
class Label extends StatelessWidget {
  /// 创建一个文本标签。
  ///
  /// [text] 为需要显示的文本；当 [isAutoSize] 为 `true` 时，
  /// 会使用 [AutoSizeText] 根据可用空间自动调整字号。
  const Label({
    super.key,
    required this.text,
    this.isAutoSize = false,
    this.textColor = Colors.black,
    this.textAlign = TextAlign.center,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap,
    this.fontFamily,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.lineHeight,
    this.shadows,
    this.decoration,
    this.decorationColor,
    this.decorationThickness,
  });

  /// 需要显示的文本。
  final String text;

  /// 是否根据可用空间自动调整文字大小。
  final bool isAutoSize;

  /// 文字颜色。
  final Color textColor;

  /// 文字的水平对齐方式。
  final TextAlign textAlign;

  /// 最大显示行数。
  ///
  /// 显示不限制行数的多行文字时，需要将 [maxLines] 和 [overflow] 同时设为 `null`。
  final int? maxLines;

  /// 文字超出可用空间时的处理方式。
  final TextOverflow? overflow;

  /// 是否允许文字自动换行。
  final bool? softWrap;

  /// 文字使用的字体族名称。
  final String? fontFamily;

  /// 文字大小。
  final double fontSize;

  /// 文字粗细。
  final FontWeight fontWeight;

  /// 行高倍数。
  final double? lineHeight;

  /// 文字阴影列表。
  final List<Shadow>? shadows;

  /// 文字装饰线类型。
  final TextDecoration? decoration;

  /// 文字装饰线颜色。
  final Color? decorationColor;

  /// 文字装饰线粗细。
  final double? decorationThickness;

  @override
  Widget build(BuildContext context) {
    if (isAutoSize) {
      return AutoSizeText(
        text,
        softWrap: softWrap,
        style: TextStyle(
          color: textColor,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: lineHeight,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationThickness: decorationThickness,
          shadows: shadows,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
    return Text(
      text,
      softWrap: softWrap,
      style: TextStyle(
        color: textColor,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: lineHeight,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
        shadows: shadows,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
