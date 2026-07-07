---
name: flutter_bottom_sheet_pickers
description: Use when coding with flutter_bottom_sheet_pickers: bottom sheet single/multiple/cascade pickers, lazy loading, search, checkboxes, custom rows, localizations, date/dateRange calendars, yearMonth pickers, and theming.
---

# flutter_bottom_sheet_pickers Agent Context

Use this package for chainable Flutter bottom sheet pickers: single, multiple, cascade, lazy/search lists, dates, date ranges, year-month, and year-month ranges.

## Import

```dart
import 'package:flutter_bottom_sheet_pickers/flutter_bottom_sheet_pickers.dart';
```

## Entry Points

```dart
BottomSheetPickers.single<T>(context);       // Future<T?>
BottomSheetPickers.multiple<T>(context);     // Future<List<T>?>
BottomSheetPickers.cascade(context);         // Future<CascadeSelection?>
BottomSheetPickers.calendar(context);        // Future<DateTime?>
BottomSheetPickers.dateRange(context);       // Future<DateTimeRange?>
BottomSheetPickers.yearMonth(context);       // Future<YearMonth?> or YearMonthRange
```

## Single and Multiple

```dart
final fruit = await BottomSheetPickers.single<String>(
  context,
  title: "Choose a fruit",
).options(["Apple", "Orange"], initialValue: "Apple").show();

final tags = await BottomSheetPickers.multiple<String>(
  context,
  title: "Choose tags",
).options(["New", "Popular"], initialValue: ["New"]).checkbox().show();
```

Use `.searchSupported(placeholder: "...")` for local filtering or lazy keyword forwarding. Use `.confirmOnTap()` only on single pickers. Use `.fullRow(...)` when custom row UI owns selected state.

## Lazy Loading

```dart
final store = await BottomSheetPickers.single<String>(context)
    .lazyLoad(
      parameters: {"country": "TH"},
      lazyRequestFuture: (params) async {
        final pageIndex = params["page_index"] as int;
        final pageSize = params["page_size"] as int;
        final keyword = params["keyword"] as String?;
        return loadStores(pageIndex, pageSize, keyword);
      },
    )
    .searchSupported()
    .show();
```

## Cascade

```dart
final selected = await BottomSheetPickers.cascade(context)
    .options([
      CascadeOption(
        id: "province_a",
        label: "Province A",
        children: [
          CascadeOption(id: "city_a", label: "City A"),
        ],
      ),
    ])
    .initialValue(CascadeSelection.byIds("province_a", "city_a"))
    .cascadeAllItemSupported()
    .show();
```

Call `.multiple()` on the cascade builder for `Future<List<CascadeSelection>?>`.

## Calendar

```dart
final date = await BottomSheetPickers.calendar(
  context,
  calendarType: CalendarType.buddhist,
  initialDate: DateTime.now(),
  firstDate: DateTime(2020, 1, 1),
  lastDate: DateTime(2030, 12, 31),
).show();

final range = await BottomSheetPickers.dateRange(
  context,
  initialDateRange: DateTimeRange(
    start: DateTime(2024, 6, 1),
    end: DateTime(2024, 6, 10),
  ),
).show();
```

Supported `CalendarType`: `gregorian`, `lunar`, `buddhist`, `tibetan`, `islamic`, `yi`, `hebrew`.

## Year Month

```dart
final ym = await BottomSheetPickers.yearMonth(
  context,
  initialYearMonth: const YearMonth(2024, 6),
).show();

final ymRange = await BottomSheetPickers.yearMonth(
  context,
  initialYearMonthRange: YearMonthRange(
    start: const YearMonth(2024, 6),
    end: const YearMonth(2024, 8),
  ),
  isRange: true,
).show();
```

## Localization and Theme

```dart
BottomSheetPickers.setLocalizations(
  localizations: BottomPickerLocalizations.zh,
);

const theme = BottomPickerTheme(
  primaryColor: Color(0xFF1677FF),
  buttonBorderRadius: BorderRadius.all(Radius.circular(16)),
);
```

## Notes for Agents

- Do not instantiate hidden builder classes directly; use `BottomSheetPickers`.
- Preserve chain order but call `.show()` last.
- `CalendarType` changes display labels; returned values are still `DateTime`, `DateTimeRange`, `YearMonth`, or `YearMonthRange`.
- Use `BottomPickerConfig` for subtree-specific labels and `BottomSheetPickers.setLocalizations` for global labels.
