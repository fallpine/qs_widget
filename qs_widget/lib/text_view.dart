import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextView extends StatelessWidget {
  /// Func
  const TextView({
    super.key,
    this.controller,
    this.placeholder,
    this.textColor = Colors.black,
    this.placeholderColor,
    this.textAlign = TextAlign.left,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.maxLength,
    this.isShowCounterText = false,
    this.autofocus = false,
    this.focusNode,
    this.keyboardType,
    this.enable = true,
    this.isDense = true,
    this.textInputAction,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
  });

  /// Property
  final TextEditingController? controller;
  final String? placeholder;
  final Color textColor;
  final Color? placeholderColor;
  final TextAlign textAlign;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  final int? maxLength;
  final bool isShowCounterText;
  final TextInputType? keyboardType;
  final bool enable;
  final bool isDense; // 是否让输入框的上下边距更紧凑

  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Widget
  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: textAlign,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofocus: autofocus,
      focusNode: focusNode,
      enabled: enable,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null, // 只允许输入数字
      style: TextStyle(
        color: textColor,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      decoration: InputDecoration(
        isDense: isDense,
        contentPadding: EdgeInsets.zero,
        hintText: placeholder,
        border: InputBorder.none, // 去掉下方的横线
        counterText: isShowCounterText ? null : '', // 隐藏默认计数器
        hintStyle: TextStyle(
          color: placeholderColor,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
