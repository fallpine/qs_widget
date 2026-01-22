import 'package:flutter/material.dart';

class AliveView extends StatefulWidget {
  const AliveView({super.key, required this.child, this.keepAlive = true});

  final Widget child;
  final bool keepAlive;

  @override
  State<AliveView> createState() => _AliveViewState();
}

class _AliveViewState extends State<AliveView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
