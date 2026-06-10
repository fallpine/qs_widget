import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'qs_widget_platform_interface.dart';

/// 使用方法通道实现的 `qs_widget` 平台能力。
class MethodChannelQsWidget extends QsWidgetPlatform {
  /// 与原生平台通信的方法通道。
  @visibleForTesting
  final methodChannel = const MethodChannel('qs_widget');

  /// 通过方法通道获取当前运行平台的版本信息。
  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
