import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichLabel extends StatelessWidget {
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

  final String text;
  final TextStyle? baseStyle;
  final TextAlign textAlign;
  final Map<String, RichLabelStyle>? matchedStrings;
  final int? maxLines;
  final TextOverflow? overflow;
  final double borderWidth;
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

  List<_MatchResult> _findAllMatches() {
    final List<_MatchResult> allMatches = [];

    for (final entry in matchedStrings!.entries) {
      final pattern = entry.key;
      final style = entry.value;

      String searchText = style.ignoreCase ? text.toLowerCase() : text;
      String searchPattern = style.ignoreCase ? pattern.toLowerCase() : pattern;

      int startIndex = 0;
      while (true) {
        int index = searchText.indexOf(searchPattern, startIndex);
        if (index == -1) break;

        allMatches.add(_MatchResult(start: index, end: index + pattern.length, style: style));

        startIndex = index + pattern.length;
      }
    }

    // 按开始位置排序，确保正确的渲染顺序
    allMatches.sort((a, b) => a.start.compareTo(b.start));

    // 处理重叠的匹配
    return _resolveOverlappingMatches(allMatches);
  }

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
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final String? fontFamily;
  final bool ignoreCase;
  final TextDecoration decoration;
  final TextDecorationStyle decorationStyle;
  final Color? decorationColor;
  final VoidCallback? onTap;

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
  final int start;
  final int end;
  final RichLabelStyle style;

  const _MatchResult({required this.start, required this.end, required this.style});
}
