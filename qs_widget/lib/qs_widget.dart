
import 'qs_widget_platform_interface.dart';

class QsWidget {
  Future<String?> getPlatformVersion() {
    return QsWidgetPlatform.instance.getPlatformVersion();
  }
}
