# qs_widget

`qs_widget` 是一个 Flutter 常用 UI 组件库，提供容器、按钮、文本、富文本、
输入框、图片、开关、页面保活和全局浮层等组件。

## 环境要求

- Dart SDK：`^3.10.3`
- Flutter：`>=3.3.0`

## 安装

在项目的 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  qs_widget: ^1.0.3
```

然后执行：

```shell
flutter pub get
```

当前组件按文件分别导出，使用时需要导入对应文件：

```dart
import 'package:qs_widget/box.dart';
import 'package:qs_widget/button.dart';
import 'package:qs_widget/label.dart';
```

## Box

`Box` 是支持尺寸、间距、背景、边框、圆角、阴影、渐变和内容裁剪的通用容器。

```dart
import 'package:flutter/material.dart';
import 'package:qs_widget/box.dart';

const Box(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16),
  color: Colors.white,
  outerRadius: BorderRadius.all(Radius.circular(12)),
  boxShadows: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ],
  child: Text('Box 内容'),
)
```

设置 `isCircle: true` 可以创建圆形容器。`outerRadius` 控制外层装饰圆角，
`innerRadius` 控制子组件的裁剪圆角。

## Button

`Button` 支持普通、选中和禁用三种状态。

```dart
import 'package:flutter/material.dart';
import 'package:qs_widget/button.dart';
import 'package:qs_widget/label.dart';

Button(
  width: 160,
  height: 48,
  normalBackgroundColor: Colors.blue,
  selectedBackgroundColor: Colors.green,
  disabledBackgroundColor: Colors.grey,
  outerRadius: BorderRadius.circular(8),
  isSelected: false,
  isEnabled: true,
  normalChild: const Label(
    text: '提交',
    textColor: Colors.white,
  ),
  selectedChild: const Label(
    text: '已选择',
    textColor: Colors.white,
  ),
  disabledChild: const Label(
    text: '不可用',
    textColor: Colors.white,
  ),
  onTap: () {
    debugPrint('点击按钮');
  },
)
```

未设置 `selectedChild` 或 `disabledChild` 时，会回退使用 `normalChild`。
当 `isEnabled` 为 `false` 时，不会触发 `onTap`。

## Label

`Label` 用于显示普通文本，也可以根据可用空间自动缩放文字。

```dart
import 'package:flutter/material.dart';
import 'package:qs_widget/label.dart';

const Label(
  text: '这是一段文本',
  textColor: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  textAlign: TextAlign.left,
  maxLines: 2,
)
```

启用自动字号：

```dart
const Label(
  text: '文字会根据可用空间自动调整大小',
  isAutoSize: true,
  fontSize: 20,
  maxLines: 1,
)
```

如需显示不限制行数的多行文本，请同时设置：

```dart
const Label(
  text: '多行文本内容',
  maxLines: null,
  overflow: null,
)
```

## RichLabel

`RichLabel` 可以为指定文字设置独立样式、点击事件和描边效果。

```dart
import 'package:flutter/material.dart';
import 'package:qs_widget/rich_label.dart';

RichLabel(
  text: '阅读并同意用户协议和隐私政策',
  baseStyle: const TextStyle(
    color: Colors.black54,
    fontSize: 14,
  ),
  matchedStrings: {
    '用户协议': RichLabelStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
      onTap: () {
        debugPrint('点击用户协议');
      },
    ),
    '隐私政策': RichLabelStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      onTap: () {
        debugPrint('点击隐私政策');
      },
    ),
  },
)
```

通过 `borderWidth` 和 `borderColor` 可以添加文字描边。

## TextView

`TextView` 是无默认边框的轻量文本输入框。

```dart
import 'package:flutter/material.dart';
import 'package:qs_widget/text_view.dart';

final controller = TextEditingController();

TextView(
  controller: controller,
  placeholder: '请输入手机号',
  keyboardType: TextInputType.number,
  maxLength: 11,
  textColor: Colors.black,
  placeholderColor: Colors.grey,
  onChanged: (value) {
    debugPrint('当前内容：$value');
  },
  onSubmitted: (value) {
    debugPrint('提交内容：$value');
  },
)
```

当 `keyboardType` 为 `TextInputType.number` 时，组件只允许输入数字。
默认隐藏字符计数器，可通过 `isShowCounterText: true` 显示。

## ImageView

`ImageView` 统一支持资源图片、SVG、网络图片和本地文件图片。

### 资源图片

```dart
import 'package:qs_widget/image_view.dart';

const ImageView(
  type: ImageType.asset,
  imageSrc: 'assets/images/avatar.png',
  width: 80,
  height: 80,
  isCircle: true,
)
```

### SVG 图片

```dart
const ImageView(
  type: ImageType.svg,
  imageSrc: 'assets/images/icon.svg',
  width: 24,
  height: 24,
)
```

### 网络图片

```dart
import 'package:flutter/material.dart';
import 'package:qs_widget/image_view.dart';

ImageView(
  type: ImageType.network,
  imageSrc: 'https://example.com/image.png',
  width: 200,
  height: 120,
  outerRadius: BorderRadius.circular(12),
  placeholder: const Center(child: CircularProgressIndicator()),
  error: const Center(child: Icon(Icons.broken_image)),
)
```

### 本地文件图片

```dart
ImageView(
  type: ImageType.file,
  imageSrc: imageFile.path,
  width: 120,
  height: 120,
)
```

图片类型与 `imageSrc` 的对应关系：

| 类型 | `imageSrc` 内容 |
| --- | --- |
| `ImageType.asset` | Flutter 资源路径 |
| `ImageType.svg` | Flutter SVG 资源路径 |
| `ImageType.network` | 网络图片 URL |
| `ImageType.file` | 设备本地文件路径 |

## SwitchButton

`SwitchButton` 使用白色滑块，并隐藏默认轨道轮廓。

```dart
import 'package:flutter/material.dart';
import 'package:qs_widget/switch_button.dart';

SwitchButton(
  value: isEnabled,
  activeTrackColor: Colors.blue,
  inactiveTrackColor: Colors.grey.shade300,
  onChanged: (value) {
    setState(() {
      isEnabled = value;
    });
  },
)
```

## AliveView

`AliveView` 用于在 `TabBarView`、`PageView` 等可滚动视图中保留子组件状态。

```dart
import 'package:qs_widget/alive_view.dart';

const AliveView(
  keepAlive: true,
  child: YourPage(),
)
```

设置 `keepAlive: false` 可以关闭状态保活。

## KeyWindow

`KeyWindow` 通过 `Overlay` 显示全局浮层。同一时间只保留一个浮层，
重复调用 `show` 会先移除已有内容。

```dart
import 'package:flutter/material.dart';
import 'package:qs_widget/key_window.dart';

KeyWindow.show(
  context: context,
  top: 100,
  right: 16,
  child: Material(
    color: Colors.transparent,
    child: Container(
      padding: const EdgeInsets.all(12),
      color: Colors.black87,
      child: const Text(
        '浮层内容',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ),
);
```

隐藏浮层：

```dart
KeyWindow.hide();
```

## 平台版本

插件保留了获取当前平台版本的接口：

```dart
import 'package:qs_widget/qs_widget.dart';

final version = await QsWidget().getPlatformVersion();
```

## 许可证

请根据项目仓库中的许可证文件使用本插件。
