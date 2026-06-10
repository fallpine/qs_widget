import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'qs_widget_method_channel.dart';

/// `qs_widget` 插件的平台能力抽象接口。
abstract class QsWidgetPlatform extends PlatformInterface {
  /// 创建平台接口实例，并绑定用于校验实现类的令牌。
  QsWidgetPlatform() : super(token: _token);

  /// 平台实现注册时使用的校验令牌。
  static final Object _token = Object();

  /// 当前生效的平台实现。
  static QsWidgetPlatform _instance = MethodChannelQsWidget();

  /// 获取当前生效的平台实现。
  ///
  /// 默认值为 [MethodChannelQsWidget]。
  static QsWidgetPlatform get instance => _instance;

  /// 注册当前平台对应的实现。
  ///
  /// [instance] 必须继承 [QsWidgetPlatform] 并通过平台接口令牌校验。
  static set instance(QsWidgetPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 获取当前运行平台的版本信息。
  ///
  /// 平台实现类需要覆写此方法。
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
