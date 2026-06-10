import 'package:flutter/material.dart';

/// 控制子组件是否在可滚动视图中保持存活的组件。
class AliveView extends StatefulWidget {
  /// 创建一个存活状态容器。
  ///
  /// [child] 为需要显示的子组件，[keepAlive] 决定其离开可视区域后是否保留状态。
  const AliveView({super.key, required this.child, this.keepAlive = true});

  /// 需要保持状态并显示的子组件。
  final Widget child;

  /// 子组件离开可视区域后是否保持存活。
  final bool keepAlive;

  @override
  State<AliveView> createState() => _AliveViewState();
}

/// [AliveView] 对应的状态对象。
class _AliveViewState extends State<AliveView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
