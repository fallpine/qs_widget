import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 无默认边框的轻量文本输入组件。
class TextView extends StatelessWidget {
  /// 创建一个文本输入框。
  ///
  /// [controller] 用于读写输入内容，[placeholder] 为占位提示文字；
  /// 当 [keyboardType] 为 [TextInputType.number] 时仅允许输入数字。
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

  /// 文本编辑控制器。
  final TextEditingController? controller;

  /// 输入内容为空时显示的占位文字。
  final String? placeholder;

  /// 输入文字颜色。
  final Color textColor;

  /// 占位文字颜色。
  final Color? placeholderColor;

  /// 输入文字的水平对齐方式。
  final TextAlign textAlign;

  /// 输入文字和占位文字使用的字体族名称。
  final String? fontFamily;

  /// 输入文字和占位文字大小。
  final double? fontSize;

  /// 输入文字和占位文字粗细。
  final FontWeight? fontWeight;

  /// 最大显示行数。
  final int? maxLines;

  /// 允许输入的最大字符数。
  final int? maxLength;

  /// 是否显示输入字符计数器。
  final bool isShowCounterText;

  /// 软键盘输入类型。
  final TextInputType? keyboardType;

  /// 输入框是否可用。
  final bool enable;

  /// 是否使用紧凑的上下边距。
  final bool isDense;

  /// 是否在组件创建后自动获取焦点。
  final bool autofocus;

  /// 输入框使用的焦点节点。
  final FocusNode? focusNode;

  /// 软键盘操作按钮的类型。
  final TextInputAction? textInputAction;

  /// 点击输入框时的回调。
  final VoidCallback? onTap;

  /// 输入内容发生变化时的回调，参数为最新文本。
  final ValueChanged<String>? onChanged;

  /// 提交输入内容时的回调，参数为已提交文本。
  final ValueChanged<String>? onSubmitted;

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
