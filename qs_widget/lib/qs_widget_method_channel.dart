import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'qs_widget_platform_interface.dart';

/// An implementation of [QsWidgetPlatform] that uses method channels.
class MethodChannelQsWidget extends QsWidgetPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('qs_widget');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
