import 'qs_widget_platform_interface.dart';

/// `qs_widget` 插件对外提供的平台功能入口。
class QsWidget {
  /// 获取当前运行平台的版本信息。
  Future<String?> getPlatformVersion() {
    return QsWidgetPlatform.instance.getPlatformVersion();
  }
}
