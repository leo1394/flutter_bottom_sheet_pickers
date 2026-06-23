# flutter_bottom_sheet_pickers
[![pub package](https://img.shields.io/pub/v/flutter_bottom_sheet_pickers.svg)](https://pub.dev/packages/flutter_bottom_sheet_pickers)
[![pub points](https://img.shields.io/pub/points/flutter_bottom_sheet_pickers?color=2E8B57&label=pub%20points)](https://pub.dev/packages/flutter_bottom_sheet_pickers/score)
[![GitHub Issues](https://img.shields.io/github/issues/leo1394/flutter_bottom_sheet_pickers.svg?branch=master)](https://github.com/leo1394/flutter_bottom_sheet_pickers/issues)
[![GitHub Forks](https://img.shields.io/github/forks/leo1394/flutter_bottom_sheet_pickers.svg?branch=master)](https://github.com/leo1394/flutter_bottom_sheet_pickers/network)
[![GitHub Stars](https://img.shields.io/github/stars/leo1394/flutter_bottom_sheet_pickers.svg?branch=master)](https://github.com/leo1394/flutter_bottom_sheet_pickers/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT%20-blue.svg)](https://raw.githubusercontent.com/leo1394/flutter_bottom_sheet_pickers/master/LICENSE)

Customizable Flutter bottom sheet pickers for single selection, multiple selection, searchable lists, paged lazy loading, and up to three-level cascade selection.

Use it for form fields, filters, region pickers, store pickers, organization trees, and remote option lists that should feel native inside a Flutter bottom sheet. The package depends only on the Flutter SDK and exposes chainable builders, so most pickers can be opened with one short expression.

## Features

- Single and multiple bottom sheet pickers
- Searchable local option lists
- Paged lazy loading for remote option lists
- Single and multiple cascade pickers with up to three levels
- Cascade options from `CascadeOption`, map-like lists, or adjacency maps
- Disabled options, optional empty confirmation, and custom option rows
- Built-in cancel, reset, and confirm actions
- Configurable primary color and action button border radius
- Built-in labels for English, simplified Chinese, traditional Chinese, Thai, Burmese, Brazilian Portuguese, Canadian French, Italian, and Spanish

Language: English | [中文](README.md)

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: |:---:| :---: | :-----: |
|   ✅    | ✅  |  ✅   |  ✅   |  ✅   |   ✅    |

## Requirements

- Flutter >=3.13.0 <4.0.0
- Dart >=3.1.0 <4.0.0

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bottom_sheet_pickers: ^0.1.0
```

Import it:

```dart
import 'package:flutter_bottom_sheet_pickers/flutter_bottom_sheet_pickers.dart';
```

## API overview

| Entry point | Use case | Return value |
| --- | --- | --- |
| `BottomSheetPickers.single<T>(context)` | Single selection, searchable single selection, lazy single selection | `Future<T?>` |
| `BottomSheetPickers.multiple<T>(context)` | Multiple selection, searchable multiple selection, lazy multiple selection | `Future<List<T>?>` |
| `BottomSheetPickers.cascade(context)` | Up to three-level cascade single selection | `Future<CascadeSelection?>` |
| `BottomSheetPickers.cascade(context).multiple()` | Up to three-level cascade multiple selection | `Future<List<CascadeSelection>?>` |
| `BottomSheetPickers.setLocalizations(...)` | App-wide picker labels | `void` |
| `BottomPickerConfig(...)` | Local picker labels for one widget subtree | `Widget` |

## Getting started

### Single Picker

```dart
final String? selected = await BottomSheetPickers.single<String>(
  context,
  title: "Choose a fruit",
).options(
  ["Apple", "Orange", "Banana"],
  initialValue: "Apple",
).show();
```

### Multiple Picker

```dart
final List<String>? selected = await BottomSheetPickers.multiple<String>(
  context,
  title: "Choose tags",
).options(
  ["New", "Popular", "Recommended"],
  initialValue: ["New"],
).show();
```

### Search

```dart
final String? selected = await BottomSheetPickers.single<String>(
  context,
  title: "Choose a city",
).options(cities)
    .searchSupported(placeholder: "Search city")
    .show();
```

### Lazy Loading

```dart
final String? selected = await BottomSheetPickers.single<String>(
  context,
  title: "Choose a store",
).lazyLoad(
  parameters: {"country": "TH"},
  lazyRequestFuture: (params) async {
    final pageIndex = params["page_index"] as int;
    final pageSize = params["page_size"] as int;
    final keyword = params["keyword"] as String?;
    return loadStores(pageIndex: pageIndex, pageSize: pageSize, keyword: keyword);
  },
).show();
```

The lazy loader receives `page_index`, `page_size`, and `keyword` in the parameter map and should return the current page as `List<T>`. When search is enabled, `keyword` contains the active search text.

### Cascade Picker

```dart
final CascadeSelection? selected = await BottomSheetPickers.cascade(
  context,
  title: "Choose location",
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

### Multiple Cascade Picker

```dart
final List<CascadeSelection>? selected = await BottomSheetPickers.cascade(
  context,
  title: "Choose locations",
).options(options)
    .multiple()
    .initialValues([
      CascadeSelection.byIds("province_a", "city_a", "town_a"),
    ])
    .cascadeAllItemSupported(allItemLabel: "All")
    .show();
```

### Map-like Cascade Data

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

The parser reads the option label from `label`, `value`, `name`, then `id`.

You can also pass an adjacency map. Each key is a parent id, and its list contains the child nodes:

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

Use `CascadeSelection.byIds(...)` for initial values. The picker resolves those ids against the option tree and returns a `CascadeSelection` containing the matched `CascadeOption` objects.

### Disabled options and empty confirmation

```dart
final selected = await BottomSheetPickers.multiple<String>(
  context,
  title: "Choose tags",
).options(
  tags,
  disabledValues: ["Archived"],
).allowNoSelection()
    .show();
```

`disabledValues` are compared with the option value. For cascade pickers, pass the option ids or values that should be disabled. `allowNoSelection()` lets users confirm without selecting an item.

## Return Values

- Confirm in a single picker returns `T?`.
- Confirm in a multiple picker returns `List<T>?`.
- Confirm in a single cascade picker returns `CascadeSelection?`.
- Confirm in a multiple cascade picker returns `List<CascadeSelection>?`.
- Cancel, tapping outside the sheet, and system back return `null`.
- Reset returns an empty list for multiple pickers and a reset selection for single cascade pickers.

## Theme

`BottomPickerTheme` derives button background, button border, checked color, selected option background, and disabled button background from `primaryColor`.

```dart
final selected = await BottomSheetPickers.single<String>(
  context,
  title: "Choose a fruit",
  themeData: const BottomPickerTheme(
    primaryColor: Color(0xFF1677FF),
    buttonBorderRadius: BorderRadius.all(Radius.circular(12)),
  ),
).options(fruits).show();
```

## Localization

The package does not require a localization delegate. By default, labels are resolved from the current Flutter locale, then the platform locale, then English.

Built-in labels are available through:

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

For app-level configuration:

```dart
BottomSheetPickers.setLocalizations(
  localizations: BottomPickerLocalizations.byLocale(currentLocale),
);
```

For apps that use their own localization extension:

```dart
BottomSheetPickers.setLocalizations(
  builder: (context) => BottomPickerLocalizations(
    cancel: context.i18n("cancel"),
    reset: context.i18n("reset"),
    confirm: context.i18n("confirm"),
  ),
);
```

Unset labels fall back to the built-in labels for the active locale.

Use `BottomPickerConfig` when only one subtree needs a local override:

```dart
BottomPickerConfig(
  localizations: BottomPickerLocalizations.zh,
  child: PageContent(),
)
```

## Additional information

- The runnable example app lives in `example/`.
- Before publishing, run `flutter analyze`, `flutter test`, and `flutter pub publish --dry-run`.
- Feel free to file an issue if you have any problem or feature request.
