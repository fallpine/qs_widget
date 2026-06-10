import 'package:flutter/material.dart';

/// 在当前应用的 [Overlay] 中显示和隐藏全局浮层。
class KeyWindow {
  /// 显示一个浮层。
  ///
  /// [context] 用于获取当前 [Overlay]，[child] 为浮层内容；
  /// [top]、[left]、[bottom] 和 [right] 用于确定浮层位置。
  /// 重复调用时会先移除已经显示的浮层。
  static void show({
    required BuildContext context,
    required Widget child,
    double? top,
    double? left,
    double? bottom,
    double? right,
  }) {
    // 如果已存在，先移除
    _entry?.remove();
    _entry = OverlayEntry(
      builder: (_) => Positioned(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: child,
      ),
    );
    if (context.mounted && _entry != null) {
      Overlay.of(context).insert(_entry!);
    }
  }

  /// 隐藏当前显示的浮层。
  static void hide() {
    _entry?.remove();
    _entry = null;
  }

  /// 当前插入到 [Overlay] 中的浮层条目。
  static OverlayEntry? _entry;
}
