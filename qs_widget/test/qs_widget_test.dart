import 'package:flutter_test/flutter_test.dart';
import 'package:qs_widget/qs_widget.dart';
import 'package:qs_widget/qs_widget_platform_interface.dart';
import 'package:qs_widget/qs_widget_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockQsWidgetPlatform
    with MockPlatformInterfaceMixin
    implements QsWidgetPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final QsWidgetPlatform initialPlatform = QsWidgetPlatform.instance;

  test('$MethodChannelQsWidget is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelQsWidget>());
  });

  test('getPlatformVersion', () async {
    QsWidget qsWidgetPlugin = QsWidget();
    MockQsWidgetPlatform fakePlatform = MockQsWidgetPlatform();
    QsWidgetPlatform.instance = fakePlatform;

    expect(await qsWidgetPlugin.getPlatformVersion(), '42');
  });
}
