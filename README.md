# flutter_bottom_sheet_pickers
[![pub package](https://img.shields.io/pub/v/flutter_bottom_sheet_pickers.svg)](https://pub.dev/packages/flutter_bottom_sheet_pickers)
[![pub points](https://img.shields.io/pub/points/flutter_bottom_sheet_pickers?color=2E8B57&label=pub%20points)](https://pub.dev/packages/flutter_bottom_sheet_pickers/score)
[![GitHub Issues](https://img.shields.io/github/issues/leo1394/flutter_bottom_sheet_pickers.svg?branch=master)](https://github.com/leo1394/flutter_bottom_sheet_pickers/issues)
[![GitHub Forks](https://img.shields.io/github/forks/leo1394/flutter_bottom_sheet_pickers.svg?branch=master)](https://github.com/leo1394/flutter_bottom_sheet_pickers/network)
[![GitHub Stars](https://img.shields.io/github/stars/leo1394/flutter_bottom_sheet_pickers.svg?branch=master)](https://github.com/leo1394/flutter_bottom_sheet_pickers/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT%20-blue.svg)](https://raw.githubusercontent.com/leo1394/flutter_bottom_sheet_pickers/master/LICENSE)

`flutter_bottom_sheet_pickers` 是一个面向 Flutter 的底部弹窗选择器集合，当前支持单选、多选、搜索、分页懒加载、最多三级级联选择。

它适合需要快速完成表单选择、筛选条件、地区/门店/组织层级选择、远程分页数据选择等场景的 Flutter 应用。包本身只依赖 Flutter SDK，API 采用链式 builder，通常一段代码即可打开 picker 并拿到返回值。

## 功能特性

- 单选选择器
- 多选选择器
- 搜索选择器
- 分页懒加载选择器，适合远程数据源
- 最多三级级联选择器，支持单选和多选
- 支持禁用部分选项、允许空选择确认、自定义 option row
- 底部弹窗布局，内置 cancel、reset、confirm 操作
- 点击弹窗外区域会关闭弹窗，返回值与点击 cancel 一致
- 支持主题色和按钮圆角配置
- 内置英文、简体中文、繁体中文、泰文、缅甸语、巴西葡萄牙语、加拿大法语、意大利语、西班牙语文案

语言: 中文 | [English](README-EN.md)

## 平台支持

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: |:---:| :---: | :-----: |
|   ✅    | ✅  |  ✅   |  ✅   |  ✅   |   ✅    |

## 依赖要求

- Flutter >=3.13.0 <4.0.0
- Dart >=3.1.0 <4.0.0

## 安装

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  flutter_bottom_sheet_pickers: ^0.1.0
```

导入：

```dart
import 'package:flutter_bottom_sheet_pickers/flutter_bottom_sheet_pickers.dart';
```

## API 速查

| 入口 | 用途 | 返回值 |
| --- | --- | --- |
| `BottomSheetPickers.single<T>(context)` | 普通单选、搜索单选、懒加载单选 | `Future<T?>` |
| `BottomSheetPickers.multiple<T>(context)` | 普通多选、搜索多选、懒加载多选 | `Future<List<T>?>` |
| `BottomSheetPickers.cascade(context)` | 最多三级级联单选 | `Future<CascadeSelection?>` |
| `BottomSheetPickers.cascade(context).multiple()` | 最多三级级联多选 | `Future<List<CascadeSelection>?>` |
| `BottomSheetPickers.setLocalizations(...)` | 设置全局 picker 文案 | `void` |
| `BottomPickerConfig(...)` | 对局部 widget subtree 覆盖 picker 文案 | `Widget` |

## 快速上手

### 单选

```dart
final selected = await BottomSheetPickers.single<String>(
  context,
  title: "选择水果",
).options(
  ["Apple", "Orange", "Banana"],
  initialValue: "Apple",
).show();
```

### 单选点击即确认

```dart
final selected = await BottomSheetPickers.single<String>(
  context,
  title: "选择水果",
).options(
  ["Apple", "Orange", "Banana"],
).confirmOnTap()
    .show();
```

### 指定弹窗高度

```dart
final selected = await BottomSheetPickers.single<String>(
  context,
  title: "选择水果",
).height(360)
    .options(["Apple", "Orange", "Banana"])
    .show();
```

### 多选

```dart
final List<String>? selected = await BottomSheetPickers.multiple<String>(
  context,
  title: "选择标签",
).options(
  ["New", "Popular", "Recommended"],
  initialValue: ["New"],
).show();
```

### 搜索

```dart
final selected = await BottomSheetPickers.single<String>(
  context,
  title: "选择城市",
).options(cities)
    .searchSupported(placeholder: "搜索城市")
    .show();
```

### 分页懒加载

```dart
final future = (params) async {
  final pageIndex = params["page_index"] as int;
  final pageSize = params["page_size"] as int;
  final keyword = params["keyword"] as String?;
  return loadStores(pageIndex: pageIndex, pageSize: pageSize, keyword: keyword);
};
final selected = await BottomSheetPickers.single<String>(
  context,
  title: "选择门店",
).lazyLoad(
  parameters: {"country": "TH"},
  lazyRequestFuture: future,
).show();
```

`lazyRequestFuture` 会收到 `page_index`、`page_size`、`keyword` 参数，并需要返回当前页的 `List<T>`。如果打开了搜索，`keyword` 会随搜索关键字一起传入。

### 级联选择

```dart
final CascadeSelection? selected = await BottomSheetPickers.cascade(
  context,
  title: "选择地区",
).options(
  [
    CascadeOption(
      id: "province_a",
      label: "Province A",
      children: [
        CascadeOption(
          id: "city_a",
          label: "City A",
          children: [
            CascadeOption(id: "town_a", label: "Town A"),
          ],
        ),
      ],
    ),
  ],
).initialValue(CascadeSelection.byIds("province_a", "city_a", "town_a"))
    .cascadeAllItemSupported()
    .show();
```

### 级联多选

```dart
final List<CascadeSelection>? selected = await BottomSheetPickers.cascade(
  context,
  title: "选择多个地区",
).options(options)
    .multiple()
    .initialValues([
      CascadeSelection.byIds("province_a", "city_a", "town_a"),
    ])
    .cascadeAllItemSupported(allItemLabel: "全部")
    .show();
```

级联选择器支持 `List<CascadeOption>`、map-like list 和 adjacency map 数据。map-like list 示例：

```dart
final options = [
  {
    "id": 1,
    "label": "Province A",
    "value": "province-a",
    "children": [
      {
        "id": 11,
        "label": "City A",
        "children": [
          {"id": 111, "label": "Town A"}
        ]
      }
    ]
  }
];
```

解析 label 时会按 `label`、`value`、`name`、`id` 顺序取值。

也可以传入 adjacency map。每个 key 表示父级 id，对应的 list 表示子节点：

```dart
final adjacencyOptions = {
  null: [
    {"id": "province_a", "label": "Province A"}
  ],
  "province_a": [
    {"id": "city_a", "label": "City A"}
  ],
  "city_a": [
    {"id": "town_a", "label": "Town A"}
  ],
};
```

`CascadeSelection.byIds(...)` 可用于设置初始值。picker 会用 id 在 options 中查找对应节点，最终返回包含真实 `CascadeOption` 对象的 `CascadeSelection`。

### 禁用选项和空选择

```dart
final selected = await BottomSheetPickers.multiple<String>(
  context,
  title: "选择标签",
).options(
  tags,
  disabledValues: ["Archived"],
).allowNoSelection()
    .show();
```

`disabledValues` 与 option 自身值比较；级联 picker 中可以传入需要禁用的 option id 或 value。`allowNoSelection()` 允许用户未选择内容时点击 confirm。

### 主题

传入 `primaryColor` 后，按钮背景色、按钮边框色、选中颜色和选中背景色会自动派生。`buttonBorderRadius` 用于配置底部 action 按钮圆角，默认是 `BorderRadius.circular(24)`。

```dart
BottomSheetPickers.single<String>(
  context,
  title: "选择水果",
  themeData: const BottomPickerTheme(
    primaryColor: Color(0xFF1677FF),
    buttonBorderRadius: BorderRadius.all(Radius.circular(12)),
  ),
).show();
```

### 返回值和取消行为

- 单选 confirm 返回 `T?`
- 多选 confirm 返回 `List<T>?`
- 级联单选 confirm 返回 `CascadeSelection?`
- 级联多选 confirm 返回 `List<CascadeSelection>?`
- 点击 cancel、点击弹窗外区域、或系统返回关闭弹窗时返回 `null`
- reset 是独立行为：多选返回空列表，级联单选返回 reset selection

## 多语言

包内内置基础文案，不使用 delegate。没有配置时，会根据当前 Flutter `Locale` 自动选择内置语言；不识别时会使用系统语言，仍不支持则默认英文。

当前内置语言：

```dart
BottomPickerLocalizations.en
BottomPickerLocalizations.zh
BottomPickerLocalizations.zhHant
BottomPickerLocalizations.th
BottomPickerLocalizations.my
BottomPickerLocalizations.ptBR
BottomPickerLocalizations.frCA
BottomPickerLocalizations.it
BottomPickerLocalizations.es
```

```dart
BottomSheetPickers.single<String>(context).options(items).show();
```

作为工具类弹窗使用时，推荐在 app 初始化或语言切换后设置一次全局默认文案：

```dart
BottomSheetPickers.setLocalizations(
  localizations: BottomPickerLocalizations.byLocale(currentLocale),
);
```

业务语言切换时再次设置即可，新打开的 picker 会同步使用新文案：

```dart
void changeLocale(Locale locale) {
  BottomSheetPickers.setLocalizations(
    localizations: BottomPickerLocalizations.byLocale(locale),
  );
}
```

如果业务有自己的多语言扩展，可以配置动态 builder：

```dart
BottomSheetPickers.setLocalizations(
  builder: (context) => BottomPickerLocalizations(
    cancel: context.i18n("cancel"),
    reset: context.i18n("reset"),
    confirm: context.i18n("confirm"),
  ),
);
```

未配置的字段会继续按当前 locale 使用内置文案。

如需局部覆盖某个页面或区域，也可以使用 `BottomPickerConfig`：

```dart
BottomPickerConfig(
  localizations: BottomPickerLocalizations.zh,
  child: PageContent(),
)
```

## 其他信息

- 示例应用在 `example/` 目录。
- 发布前建议运行 `flutter analyze`、`flutter test` 和 `flutter pub publish --dry-run`。
- 如有问题或功能建议，欢迎提交 Issue。
