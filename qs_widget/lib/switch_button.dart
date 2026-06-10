import "package:flutter/material.dart";

/// 固定使用白色滑块且不显示轨道轮廓的开关组件。
class SwitchButton extends Switch {
  /// 创建一个自定义开关。
  ///
  /// [value] 表示当前开关状态，[onChanged] 在状态切换时回传新值；
  /// [activeTrackColor] 和 [inactiveTrackColor] 分别设置开启与关闭时的轨道颜色。
  SwitchButton({
    super.key,
    required super.value,
    required super.onChanged,
    required Color activeTrackColor,
    required Color inactiveTrackColor,
    super.activeThumbImage,
    super.onActiveThumbImageError,
    super.inactiveThumbImage,
    super.onInactiveThumbImageError,
    super.thumbColor,
    super.trackColor,
    super.trackOutlineWidth,
    super.thumbIcon,
    super.materialTapTargetSize,
    super.dragStartBehavior,
    super.mouseCursor,
    super.focusColor,
    super.hoverColor,
    super.overlayColor,
    super.splashRadius,
    super.focusNode,
    super.onFocusChange,
    super.autofocus,
    super.padding,
  }) : super(
         activeThumbColor: Colors.white,
         activeTrackColor: activeTrackColor,
         inactiveThumbColor: Colors.white,
         inactiveTrackColor: inactiveTrackColor,
         trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
       );
}
