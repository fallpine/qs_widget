import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  /// Func
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

  /// Property
  final String text;
  final bool isAutoSize;
  final Color textColor;
  final TextAlign textAlign;
  // 设置多行文字时，需要把maxLines和overflow同时设置为null
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final String? fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final double? lineHeight;
  final List<Shadow>? shadows;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;

  /// Widget
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
