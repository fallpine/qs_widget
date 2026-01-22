import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'qs_widget_method_channel.dart';

abstract class QsWidgetPlatform extends PlatformInterface {
  /// Constructs a QsWidgetPlatform.
  QsWidgetPlatform() : super(token: _token);

  static final Object _token = Object();

  static QsWidgetPlatform _instance = MethodChannelQsWidget();

  /// The default instance of [QsWidgetPlatform] to use.
  ///
  /// Defaults to [MethodChannelQsWidget].
  static QsWidgetPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [QsWidgetPlatform] when
  /// they register themselves.
  static set instance(QsWidgetPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
