import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 键盘避让
// 方法一：resizeToAvoidBottomInset: true
// 这个方法会把整个页面都往上顶
//
// 方法二：使用KeyboardAvoidanceView，把resizeToAvoidBottomInset: false
// 这个只会把KeyboardAvoidanceView里面的Widget往上顶，其他Widget不会往上顶
// 要确保KeyboardAvoidanceView里面的Widget的父组件，有足够的位置让它往上顶

class KeyboardAvoidanceView extends StatefulWidget {
  const KeyboardAvoidanceView({
    required this.child,
    this.enabled = true,
    this.spacing = 0,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutCubic,
    super.key,
  }) : assert(spacing >= 0);

  /// System Funcs
  @override
  State<KeyboardAvoidanceView> createState() => _KeyboardAvoidanceViewState();

  /// Properties
  final Widget child;
  final bool enabled;
  final double spacing;
  final Duration duration;
  final Curve curve;
}

class _KeyboardAvoidanceViewState extends State<KeyboardAvoidanceView>
    with WidgetsBindingObserver {
  /// System Funcs
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FocusManager.instance.addListener(_scheduleAvoidanceUpdate);
    _scheduleAvoidanceUpdate();
  }

  @override
  void didUpdateWidget(covariant KeyboardAvoidanceView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled ||
        oldWidget.spacing != widget.spacing) {
      _scheduleAvoidanceUpdate();
    }
  }

  @override
  void didChangeMetrics() {
    _scheduleAvoidanceUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: widget.enabled ? _translation : 0),
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, value, child) {
        _paintedTranslation = value;
        return Transform.translate(offset: Offset(0, -value), child: child);
      },
      child: KeyedSubtree(key: _contentKey, child: widget.child),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FocusManager.instance.removeListener(_scheduleAvoidanceUpdate);
    super.dispose();
  }

  /// Custom Funcs
  void _scheduleAvoidanceUpdate() {
    if (_isUpdateScheduled || !mounted) {
      return;
    }
    _isUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isUpdateScheduled = false;
      if (mounted) {
        if (_isUpdating) {
          _needsUpdate = true;
        } else {
          unawaited(_runAvoidanceUpdate());
        }
      }
    });
  }

  Future<void> _runAvoidanceUpdate() async {
    _isUpdating = true;
    try {
      do {
        _needsUpdate = false;
        await _updateAvoidance();
      } while (mounted && _needsUpdate);
    } finally {
      _isUpdating = false;
    }
  }

  Future<void> _updateAvoidance() async {
    if (!widget.enabled) {
      _updateTranslation(translation: 0);
      return;
    }

    final view = View.of(context);
    final devicePixelRatio = view.devicePixelRatio;
    final keyboardInset = view.viewInsets.bottom / devicePixelRatio;
    if (keyboardInset <= 0) {
      _updateTranslation(translation: 0);
      return;
    }

    final focusContext = FocusManager.instance.primaryFocus?.context;
    final focusRenderObject = focusContext == null
        ? null
        : _findFocusedInputRenderBox(focusContext: focusContext);
    final contentRenderObject = _contentKey.currentContext?.findRenderObject();
    if (focusContext == null ||
        focusRenderObject is! RenderBox ||
        contentRenderObject == null ||
        !_isDescendantOf(
          child: focusRenderObject,
          ancestor: contentRenderObject,
        )) {
      _updateTranslation(translation: 0);
      return;
    }

    final keyboardTop =
        view.physicalSize.height / devicePixelRatio - keyboardInset;
    final focusedBottom = focusRenderObject
        .localToGlobal(Offset(0, focusRenderObject.size.height))
        .dy;
    final requiredAvoidance = math.max(
      0.0,
      focusedBottom + _paintedTranslation + widget.spacing - keyboardTop,
    );
    if (requiredAvoidance <= 0) {
      _updateTranslation(translation: 0);
      return;
    }

    final scrollableState = _findVerticalScrollableState(
      focusContext: focusContext,
      contentRenderObject: contentRenderObject,
    );
    if (scrollableState != null) {
      final scrolledDistance = await _scrollByAvoidance(
        position: scrollableState.position,
        avoidance: requiredAvoidance,
      );
      if (!mounted) {
        return;
      }
      _updateTranslation(
        translation: math.max(0, requiredAvoidance - scrolledDistance),
      );
      return;
    }

    _updateTranslation(translation: requiredAvoidance);
  }

  Future<double> _scrollByAvoidance({
    required ScrollPosition position,
    required double avoidance,
  }) async {
    if (_isScrolling ||
        axisDirectionToAxis(position.axisDirection) != Axis.vertical) {
      return 0;
    }

    final isForward = position.axisDirection == AxisDirection.down;
    final availableDistance = isForward
        ? position.maxScrollExtent - position.pixels
        : position.pixels - position.minScrollExtent;
    final scrollDistance = math.min(avoidance, math.max(0, availableDistance));
    if (scrollDistance <= 0) {
      return 0;
    }

    _isScrolling = true;
    try {
      final targetOffset = isForward
          ? position.pixels + scrollDistance
          : position.pixels - scrollDistance;
      await position.animateTo(
        targetOffset,
        duration: widget.duration,
        curve: widget.curve,
      );
      return scrollDistance.toDouble();
    } finally {
      _isScrolling = false;
    }
  }

  bool _isDescendantOf({
    required RenderObject? child,
    required RenderObject ancestor,
  }) {
    var current = child;
    while (current != null) {
      if (identical(current, ancestor)) {
        return true;
      }
      final parent = current.parent;
      current = parent is RenderObject ? parent : null;
    }
    return false;
  }

  RenderBox? _findFocusedInputRenderBox({required BuildContext focusContext}) {
    RenderBox? inputRenderBox;
    focusContext.visitAncestorElements((element) {
      if (element.widget is TextField ||
          element.widget is TextFormField ||
          element.widget is CupertinoTextField) {
        final renderObject = element.findRenderObject();
        if (renderObject is RenderBox) {
          inputRenderBox = renderObject;
        }
        return false;
      }
      if (inputRenderBox == null && element.widget is EditableText) {
        final renderObject = element.findRenderObject();
        if (renderObject is RenderBox) {
          inputRenderBox = renderObject;
        }
      }
      return true;
    });
    return inputRenderBox;
  }

  ScrollableState? _findVerticalScrollableState({
    required BuildContext focusContext,
    required RenderObject contentRenderObject,
  }) {
    ScrollableState? scrollableState;
    focusContext.visitAncestorElements((element) {
      if (element is StatefulElement && element.state is ScrollableState) {
        final candidate = element.state as ScrollableState;
        if (axisDirectionToAxis(candidate.position.axisDirection) ==
                Axis.vertical &&
            _isDescendantOf(
              child: candidate.context.findRenderObject(),
              ancestor: contentRenderObject,
            )) {
          scrollableState = candidate;
          return false;
        }
      }
      return true;
    });
    return scrollableState;
  }

  void _updateTranslation({required double translation}) {
    if (!mounted || (_translation - translation).abs() < 0.5) {
      return;
    }
    setState(() {
      _translation = translation;
    });
  }

  /// Properties
  final GlobalKey _contentKey = GlobalKey();
  double _translation = 0;
  double _paintedTranslation = 0;
  bool _isUpdateScheduled = false;
  bool _isUpdating = false;
  bool _needsUpdate = false;
  bool _isScrolling = false;
}
