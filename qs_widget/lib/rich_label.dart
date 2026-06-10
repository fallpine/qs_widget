import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 支持局部样式、点击事件和文字描边的富文本标签。
class RichLabel extends StatelessWidget {
  /// 创建一个富文本标签。
  ///
  /// [text] 为完整文本，[matchedStrings] 的键为需要匹配的文字，
  /// 值用于配置匹配文字的样式和点击事件。
  const RichLabel({
    super.key,
    required this.text,
    this.baseStyle,
    this.textAlign = TextAlign.left,
    this.matchedStrings,
    this.maxLines,
    this.overflow,
    this.borderWidth = 0,
    this.borderColor,
  });

  /// 需要显示的完整文本。
  final String text;

  /// 未匹配文字使用的基础样式。
  final TextStyle? baseStyle;

  /// 文本的水平对齐方式。
  final TextAlign textAlign;

  /// 待匹配文字与对应样式的映射。
  final Map<String, RichLabelStyle>? matchedStrings;

  /// 最大显示行数。
  final int? maxLines;

  /// 文字超出可用空间时的处理方式。
  final TextOverflow? overflow;

  /// 文字描边宽度，小于或等于零时不绘制描边。
  final double borderWidth;

  /// 文字描边颜色，为 `null` 时不绘制描边。
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    // 如果没有边框，直接返回普通富文本
    if (borderWidth <= 0 || borderColor == null) {
      return _buildRichText();
    }

    // 有边框时，使用Stack实现描边效果
    return Stack(
      children: [
        // 描边效果
        _buildRichText(isStroke: true),
        // 前景文字
        _buildRichText(),
      ],
    );
  }

  /// 根据当前配置构建富文本。
  ///
  /// [isStroke] 表示是否构建用于描边的底层文本。
  Widget _buildRichText({bool isStroke = false}) {
    // 如果没有匹配规则，直接返回普通文本
    if (matchedStrings == null || matchedStrings!.isEmpty) {
      return Text(
        text,
        style: isStroke
            ? baseStyle?.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = borderWidth
                  ..color = borderColor!,
              )
            : baseStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(
        children: _buildTextSpans(isStroke: isStroke),
        style: isStroke
            ? baseStyle?.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = borderWidth
                  ..color = borderColor!,
              )
            : baseStyle,
      ),
    );
  }

  /// 将完整文本拆分为普通片段和匹配样式片段。
  ///
  /// [isStroke] 表示是否为匹配片段应用描边样式。
  List<TextSpan> _buildTextSpans({bool isStroke = false}) {
    final List<TextSpan> spans = [];
    final List<_MatchResult> matches = _findAllMatches();

    // 如果没有匹配结果，返回整个文本
    if (matches.isEmpty) {
      return [TextSpan(text: text)];
    }

    int currentPosition = 0;

    // 处理所有匹配结果
    for (final match in matches) {
      // 添加匹配前的普通文本
      if (match.start > currentPosition) {
        spans.add(TextSpan(text: text.substring(currentPosition, match.start)));
      }

      // 添加匹配的文本
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: isStroke
              ? match.style
                    .apply(baseStyle)
                    .copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = borderWidth
                        ..color = borderColor!,
                    )
              : match.style.apply(baseStyle),
          recognizer: match.style.onTap == null
              ? null
              : (TapGestureRecognizer()..onTap = match.style.onTap),
        ),
      );

      currentPosition = match.end;
    }

    // 添加最后一段普通文本
    if (currentPosition < text.length) {
      spans.add(TextSpan(text: text.substring(currentPosition)));
    }

    return spans;
  }

  /// 查找所有匹配文字，并过滤位置重叠的结果。
  List<_MatchResult> _findAllMatches() {
    final List<_MatchResult> allMatches = [];

    for (final entry in matchedStrings!.entries) {
      final pattern = entry.key;
      final style = entry.value;
      if (pattern.isEmpty) continue;

      String searchText = style.ignoreCase ? text.toLowerCase() : text;
      String searchPattern = style.ignoreCase ? pattern.toLowerCase() : pattern;

      int startIndex = 0;
      while (true) {
        int index = searchText.indexOf(searchPattern, startIndex);
        if (index == -1) break;

        allMatches.add(
          _MatchResult(start: index, end: index + pattern.length, style: style),
        );

        startIndex = index + pattern.length;
      }
    }

    // 按开始位置排序，确保正确的渲染顺序
    allMatches.sort((a, b) => a.start.compareTo(b.start));

    // 处理重叠的匹配
    return _resolveOverlappingMatches(allMatches);
  }

  /// 移除位置重叠的匹配项。
  ///
  /// [matches] 必须已按照起始位置升序排列。
  List<_MatchResult> _resolveOverlappingMatches(List<_MatchResult> matches) {
    if (matches.isEmpty) return matches;

    final List<_MatchResult> result = [matches.first];

    for (int i = 1; i < matches.length; i++) {
      final current = matches[i];
      final previous = result.last;

      // 如果当前匹配与前一个匹配不重叠，则添加到结果中
      if (current.start >= previous.end) {
        result.add(current);
      }
    }

    return result;
  }
}

/// 富文本匹配样式
class RichLabelStyle {
  /// 匹配文字的颜色。
  final Color? color;

  /// 匹配文字的粗细。
  final FontWeight? fontWeight;

  /// 匹配文字的大小。
  final double? fontSize;

  /// 匹配文字使用的字体族名称。
  final String? fontFamily;

  /// 匹配文字时是否忽略大小写。
  final bool ignoreCase;

  /// 匹配文字的装饰线类型。
  final TextDecoration decoration;

  /// 匹配文字的装饰线样式。
  final TextDecorationStyle decorationStyle;

  /// 匹配文字的装饰线颜色。
  final Color? decorationColor;

  /// 点击匹配文字时的回调。
  final VoidCallback? onTap;

  /// 创建一组富文本匹配样式。
  const RichLabelStyle({
    this.color,
    this.fontWeight,
    this.fontSize,
    this.fontFamily,
    this.ignoreCase = false,
    this.decoration = TextDecoration.none,
    this.decorationStyle = TextDecorationStyle.solid,
    this.decorationColor,
    this.onTap,
  });

  /// 将当前配置合并到 [baseStyle] 并生成最终文字样式。
  TextStyle apply(TextStyle? baseStyle) {
    return (baseStyle ?? const TextStyle()).copyWith(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      decoration: decoration,
      decorationStyle: decorationStyle,
      decorationColor: decorationColor,
    );
  }
}

/// 匹配结果类
class _MatchResult {
  /// 匹配内容在完整文本中的起始索引。
  final int start;

  /// 匹配内容在完整文本中的结束索引，不包含该位置。
  final int end;

  /// 匹配内容使用的样式。
  final RichLabelStyle style;

  /// 创建一个文本匹配结果。
  const _MatchResult({
    required this.start,
    required this.end,
    required this.style,
  });
}
