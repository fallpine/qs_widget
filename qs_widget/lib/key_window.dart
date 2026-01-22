import 'package:flutter/material.dart';

class KeyWindow {
  /// Func
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
      builder: (_) => Positioned(top: top, left: left, right: right, bottom: bottom, child: child),
    );
    if (context.mounted && _entry != null) {
      Overlay.of(context).insert(_entry!);
    }
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }

  /// Property
  static OverlayEntry? _entry;
}
