# flutter_bottom_sheet_pickers

Use `BottomSheetPickers` entry points: `single`, `multiple`, `cascade`, `calendar`, `dateRange`, and `yearMonth`. Chain configuration methods and call `.show()` last.

```dart
final tags = await BottomSheetPickers.multiple<String>(context)
    .options(["New", "Popular"], initialValue: ["New"])
    .checkbox()
    .show();

final date = await BottomSheetPickers.calendar(
  context,
  initialDate: DateTime.now(),
).show();
```

Use `BottomPickerTheme` for primary color/button radius and `BottomPickerLocalizations` or `BottomPickerConfig` for labels.
