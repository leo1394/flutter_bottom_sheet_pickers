import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bottom_sheet_pickers/flutter_bottom_sheet_pickers.dart';

void main() {
  tearDown(() {
    BottomSheetPickers.clearLocalizations();
  });

  test("theme data derives colors from primary color", () {
    const themeData = BottomPickerTheme(primaryColor: Color(0xFF1677FF));

    expect(themeData.buttonBackgroundColor, const Color(0xFF1677FF));
    expect(themeData.buttonBorderColor, const Color(0xFF1677FF));
    expect(themeData.checkedColor, const Color(0xFF1677FF));
    expect(themeData.selectedOptionBackgroundColor,
        const Color(0xFF1677FF).withAlpha((255 * 0.05).round()));
    expect(themeData.buttonBorderRadius,
        const BorderRadius.all(Radius.circular(24)));
  });

  test("theme data supports custom button border radius", () {
    const themeData = BottomPickerTheme(
      primaryColor: Color(0xFF1677FF),
      buttonBorderRadius: BorderRadius.all(Radius.circular(12)),
    );

    expect(themeData.buttonBorderRadius,
        const BorderRadius.all(Radius.circular(12)));
  });

  test("cascade selection by ids creates path in order", () {
    final selection = CascadeSelection.byIds(1, 2, 3);

    expect(selection.path.map((item) => item.id).toList(), ["1", "2", "3"]);
  });

  test("cascade option uses label as string value", () {
    const option = CascadeOption(id: "1", label: "Province A");

    expect(option.toString(), "Province A");
  });

  test("picker texts resolve built-in languages", () {
    expect(BottomPickerLocalizations.byLocale(const Locale("zh")).cancel, "取消");
    expect(
        BottomPickerLocalizations.byLocale(const Locale.fromSubtags(
                languageCode: "zh", scriptCode: "Hant"))
            .confirm,
        "確認");
    expect(BottomPickerLocalizations.byLocale(const Locale("en")).cancel,
        "Cancel");
    expect(BottomPickerLocalizations.byLocale(const Locale("th")).cancel,
        "ยกเลิก");
    expect(BottomPickerLocalizations.byLocale(const Locale("my")).cancel,
        "ပယ်ဖျက်");
    expect(BottomPickerLocalizations.byLocale(const Locale("pt", "BR")).confirm,
        "Confirmar");
    expect(BottomPickerLocalizations.byLocale(const Locale("fr", "CA")).reset,
        "Réinit.");
    expect(
        BottomPickerLocalizations.byLocale(const Locale("fr", "CA"))
            .searchPlaceholder,
        "Rechercher");
    expect(
        BottomPickerLocalizations.byLocale(const Locale("zh"))
            .calendarNames[CalendarType.lunar],
        "农历");
    expect(
        BottomPickerLocalizations.byLocale(const Locale.fromSubtags(
                languageCode: "zh", scriptCode: "Hant"))
            .lunarMonths
            .last,
        "臘月");
    expect(
        BottomPickerLocalizations.byLocale(const Locale("zh")).narrowWeekdays,
        ["日", "一", "二", "三", "四", "五", "六"]);
    expect(
        BottomPickerLocalizations.byLocale(const Locale("en")).narrowWeekdays,
        ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]);
    expect(
        BottomPickerLocalizations.byLocale(const Locale("en"))
            .firstDayOfWeekIndex,
        0);
    expect(
        BottomPickerLocalizations.byLocale(const Locale("en"))
            .hebrewMonths
            .first,
        "Nisan");
    expect(
        BottomPickerLocalizations.byLocale(const Locale("it")).reset, "Reset");
    expect(BottomPickerLocalizations.byLocale(const Locale("it")).noMoreData,
        "Nessun dato in più");
    expect(BottomPickerLocalizations.byLocale(const Locale("es")).empty,
        "No hay datos");
    expect(BottomPickerLocalizations.byLocale(null).cancel, "Cancel");
    expect(const BottomPickerLocalizations().cancel, "Cancel");
  });

  testWidgets("picker texts resolve from current locale", (tester) async {
    late BottomPickerLocalizations texts;

    await tester.pumpWidget(
      Localizations(
        locale: const Locale("zh"),
        delegates: const [DefaultWidgetsLocalizations.delegate],
        child: Builder(
          builder: (context) {
            texts = BottomPickerLocalizations.resolve(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(texts.confirm, "确认");
  });

  testWidgets("picker config supports fixed and dynamic texts", (tester) async {
    late BottomPickerConfig? fixedConfig;
    late BottomPickerConfig? dynamicConfig;

    await tester.pumpWidget(
      BottomPickerConfig(
        localizations: BottomPickerLocalizations.zh,
        child: Builder(
          builder: (context) {
            fixedConfig = BottomPickerConfig.maybeOf(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(fixedConfig?.localizations?.cancel, "取消");

    await tester.pumpWidget(
      BottomPickerConfig(
        localizationBuilder: (context) => BottomPickerLocalizations.en,
        child: Builder(
          builder: (context) {
            dynamicConfig = BottomPickerConfig.maybeOf(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(
        dynamicConfig?.localizationBuilder
            ?.call(tester.element(find.byType(SizedBox)))
            .cancel,
        "Cancel");
  });

  testWidgets("picker global localizations support utility calls",
      (tester) async {
    late BottomPickerLocalizations fixedTexts;
    late BottomPickerLocalizations dynamicTexts;

    BottomSheetPickers.setLocalizations(
        localizations: BottomPickerLocalizations.zh);
    await tester.pumpWidget(
      Localizations(
        locale: const Locale("en"),
        delegates: const [DefaultWidgetsLocalizations.delegate],
        child: Builder(
          builder: (context) {
            fixedTexts = BottomPickerLocalizations.resolve(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(fixedTexts.cancel, "取消");

    BottomSheetPickers.setLocalizations(
        builder: (context) => BottomPickerLocalizations.en);
    await tester.pumpWidget(
      Localizations(
        locale: const Locale("zh"),
        delegates: const [DefaultWidgetsLocalizations.delegate],
        child: Builder(
          builder: (context) {
            dynamicTexts = BottomPickerLocalizations.resolve(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(dynamicTexts.cancel, "Cancel");

    BottomSheetPickers.clearLocalizations();
  });

  testWidgets("picker local config overrides global localizations",
      (tester) async {
    late BottomPickerLocalizations texts;

    BottomSheetPickers.setLocalizations(
        localizations: BottomPickerLocalizations.en);
    await tester.pumpWidget(
      BottomPickerConfig(
        localizations: BottomPickerLocalizations.zh,
        child: Builder(
          builder: (context) {
            final config = BottomPickerConfig.maybeOf(context);
            texts = BottomPickerLocalizations.resolve(context,
                texts: config?.localizations,
                textsBuilder: config?.localizationBuilder);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(texts.cancel, "取消");

    BottomSheetPickers.clearLocalizations();
  });

  testWidgets("picker localizations fill optional labels from current locale",
      (tester) async {
    late BottomPickerLocalizations texts;

    await tester.pumpWidget(
      Localizations(
        locale: const Locale("zh"),
        delegates: const [DefaultWidgetsLocalizations.delegate],
        child: Builder(
          builder: (context) {
            texts = BottomPickerLocalizations.resolve(
              context,
              texts: const BottomPickerLocalizations(
                reset: "Reset custom",
              ),
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(texts.cancel, "取消");
    expect(texts.reset, "Reset custom");
    expect(texts.confirm, "确认");
    expect(texts.noData, "暂无数据");
    expect(texts.loadingText, "加载中...");
    expect(texts.empty, "暂无数据");
    expect(texts.noMoreData, "没有更多数据");
    expect(texts.all, "全部");
    expect(texts.searchPlaceholder, "搜索");
  });

  testWidgets(
      "picker localizations fill optional labels from app locale when app locale is supported",
      (tester) async {
    late BottomPickerLocalizations texts;
    tester.binding.platformDispatcher.localeTestValue = const Locale("zh");
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);

    BottomSheetPickers.setLocalizations(
      builder: (context) => const BottomPickerLocalizations(
        cancel: "ยกเลิก",
        confirm: "ยืนยัน",
      ),
    );

    await tester.pumpWidget(
      Localizations(
        locale: const Locale("th"),
        delegates: const [DefaultWidgetsLocalizations.delegate],
        child: Builder(
          builder: (context) {
            texts = BottomPickerLocalizations.resolve(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(texts.cancel, "ยกเลิก");
    expect(texts.confirm, "ยืนยัน");
    expect(texts.reset, "รีเซ็ต");
    expect(texts.loadingText, "กำลังโหลด...");
  });

  testWidgets("picker built-in localizations fall back per optional label",
      (tester) async {
    late BottomPickerLocalizations texts;

    await tester.pumpWidget(
      Localizations(
        locale: const Locale("pt", "BR"),
        delegates: const [DefaultWidgetsLocalizations.delegate],
        child: Builder(
          builder: (context) {
            texts = BottomPickerLocalizations.resolve(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(texts.cancel, "Cancelar");
    expect(texts.reset, "Reset");
    expect(texts.noMoreData, "No More Data");
    expect(texts.loadingText, "Carregando...");
  });

  testWidgets("cascade single dismisses when tapping outside visible sheet",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.cascade(context).options(const [
                  CascadeOption(id: "1", label: "Level 1"),
                ]).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.text("Level 1"), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.text("Level 1"), findsNothing);
  });

  testWidgets("multiple picker can show checkbox before options",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.multiple<String>(context)
                    .options(
                      const ["A", "B"],
                      initialValue: const ["A"],
                    )
                    .checkbox()
                    .show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.byType(Checkbox), findsNWidgets(2));
    expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, true);
    expect(tester.widget<Checkbox>(find.byType(Checkbox).last).value, false);

    await tester.tap(find.text("B"));
    await tester.pump();

    expect(tester.widget<Checkbox>(find.byType(Checkbox).last).value, true);
  });

  testWidgets("multiple picker local filter preserves cross filter selections",
      (tester) async {
    Future<List<String>?>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                result = BottomSheetPickers.multiple<String>(context)
                    .options(const ["PVS Store", "FS Store"])
                    .searchSupported()
                    .withFilterSupported(
                      PickerFilter<String, String>.local(
                        options: const [
                          PickerFilterOption(value: null, label: "All"),
                          PickerFilterOption(value: "PVS", label: "PVS"),
                          PickerFilterOption(value: "FS", label: "FS"),
                        ],
                        predicate: (option, filter) =>
                            filter == null || option.startsWith(filter),
                      ),
                    )
                    .show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("PVS Store"));
    await tester.pump();
    expect(find.text("Selected 1"), findsOneWidget);

    await tester.tap(find.text("All").first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("FS").last);
    await tester.pumpAndSettle();

    expect(find.text("PVS Store"), findsNothing);
    expect(find.text("FS Store"), findsOneWidget);
    expect(find.text("Selected 1"), findsOneWidget);

    await tester.tap(find.text("FS Store"));
    await tester.pump();
    expect(find.text("Selected 2"), findsOneWidget);

    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();

    expect(await result, containsAll(["PVS Store", "FS Store"]));
  });

  testWidgets("single picker remote filter forwards lazy load parameters",
      (tester) async {
    final calls = <Map<String, dynamic>>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.single<String>(context)
                    .searchSupported()
                    .withFilterSupported(
                      PickerFilter<String, String>.remote(
                        options: const [
                          PickerFilterOption(value: null, label: "All"),
                          PickerFilterOption(value: "PVS", label: "PVS"),
                        ],
                        parameterBuilder: (filter) => {
                          if (filter != null) "store_type": filter,
                        },
                      ),
                    )
                    .lazyLoad(
                  parameters: const {"type": "inspection"},
                  lazyRequestFuture: (params) async {
                    calls.add(Map<String, dynamic>.from(params));
                    return const <String>[];
                  },
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(calls.first["store_type"], isNull);

    await tester.tap(find.text("All").first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("PVS").last);
    await tester.pumpAndSettle();

    expect(calls.last["type"], "inspection");
    expect(calls.last["store_type"], "PVS");

    await tester.tap(find.text("PVS").first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("All").last);
    await tester.pumpAndSettle();

    expect(find.text("All"), findsOneWidget);
    expect(calls.last["type"], "inspection");
    expect(calls.last["store_type"], isNull);
  });

  testWidgets("calendar date picker returns selected date", (tester) async {
    Future<dynamic>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                result = BottomSheetPickers.calendar(
                  context,
                  calendarType: CalendarType.buddhist,
                  initialDate: DateTime(2024, 6, 15),
                  firstDate: DateTime(2024, 1, 1),
                  lastDate: DateTime(2024, 12, 31),
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.text("2024-06"), findsOneWidget);
    expect(find.text("Buddhist"), findsOneWidget);
    expect(find.text("15"), findsNWidgets(2));

    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();

    expect(await result, DateTime(2024, 6, 15));
  });

  testWidgets(
      "calendar day cell hides helper label when calendar type is default gregorian",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.calendar(
                  context,
                  initialDate: DateTime(2024, 6, 15),
                  firstDate: DateTime(2024, 6, 1),
                  lastDate: DateTime(2024, 6, 30),
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.text("2024-06"), findsOneWidget);
    expect(find.text("Gregorian"), findsNothing);
    expect(find.text("15"), findsOneWidget);
  });

  testWidgets(
      "calendar header stays gregorian when alternate calendar type is specified",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.calendar(context)
                    .init(initialDate: DateTime(2026, 7, 7))
                    .calendarType(CalendarType.yi)
                    .show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.text("2026-07"), findsOneWidget);
    expect(find.text("Yi"), findsOneWidget);
    expect(find.text("2025-06"), findsNothing);
    expect(find.text("7"), findsWidgets);
  });

  testWidgets("calendar renders only weeks intersecting visible month",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.calendar(
                  context,
                  initialDate: DateTime(2026, 7, 7),
                  firstDate: DateTime(2026, 1, 1),
                  lastDate: DateTime(2026, 12, 31),
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.text("2026-07"), findsOneWidget);
    expect(find.text("31"), findsOneWidget);
    expect(find.text("8"), findsOneWidget);
  });

  testWidgets("calendar header supports year navigation within bounds",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.calendar(
                  context,
                  initialDate: DateTime(2026, 7, 7),
                  firstDate: DateTime(2025, 1, 1),
                  lastDate: DateTime(2027, 12, 31),
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.keyboard_double_arrow_left), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_double_arrow_right), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.byIcon(Icons.keyboard_double_arrow_left));
    await tester.pumpAndSettle();

    expect(find.text("2025-07"), findsOneWidget);
  });

  testWidgets("calendar header hides navigation buttons outside bounds",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.calendar(
                  context,
                  initialDate: DateTime(2024, 6, 15),
                  firstDate: DateTime(2024, 6, 1),
                  lastDate: DateTime(2024, 6, 30),
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.keyboard_double_arrow_left), findsNothing);
    expect(find.byIcon(Icons.keyboard_double_arrow_right), findsNothing);
    expect(find.byIcon(Icons.chevron_left), findsNothing);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets("calendar weekdays use picker localizations", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomPickerConfig(
          localizations: BottomPickerLocalizations.zh,
          child: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  BottomSheetPickers.calendar(
                    context,
                    initialDate: DateTime(2024, 6, 15),
                    firstDate: DateTime(2024, 6, 1),
                    lastDate: DateTime(2024, 6, 30),
                  ).show();
                },
                child: const Text("open"),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.text("日"), findsOneWidget);
    expect(find.text("一"), findsOneWidget);
    expect(find.text("อา"), findsNothing);
  });

  testWidgets(
      "calendar weekdays follow inferred picker labels instead of flutter locale",
      (tester) async {
    BottomSheetPickers.setLocalizations(
      builder: (context) => const BottomPickerLocalizations(
        cancel: "Cancel",
        confirm: "Confirm",
        reset: "Reset",
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale("th"),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.calendar(
                  context,
                  initialDate: DateTime(2024, 6, 15),
                  firstDate: DateTime(2024, 6, 1),
                  lastDate: DateTime(2024, 6, 30),
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.text("Cancel"), findsOneWidget);
    expect(find.text("Confirm"), findsOneWidget);
    expect(find.text("Su"), findsOneWidget);
    expect(find.text("Sa"), findsOneWidget);
    expect(find.text("อา"), findsNothing);
  });

  testWidgets(
      "calendar day cell shows month label on first day of converted month",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.calendar(
                  context,
                  calendarType: CalendarType.lunar,
                  initialDate: DateTime(2024, 2, 10),
                  firstDate: DateTime(2024, 2, 1),
                  lastDate: DateTime(2024, 2, 29),
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.text("正月"), findsWidgets);
    expect(find.text("初一"), findsNothing);
  });

  testWidgets("calendar selected day keeps helper label visible",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.calendar(
                  context,
                  initialDate: DateTime(2024, 2, 10),
                  firstDate: DateTime(2024, 2, 1),
                  lastDate: DateTime(2024, 2, 29),
                ).calendarType(CalendarType.lunar).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    final label = tester.widget<Text>(find.text("正月").last);
    expect(label.style?.color, BottomPickerTheme.defaults.checkedColor);
  });

  testWidgets("calendar range picker returns selected range", (tester) async {
    Future<dynamic>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                result = BottomSheetPickers.dateRange(
                  context,
                  initialDateRange: DateTimeRange(
                    start: DateTime(2024, 6, 10),
                    end: DateTime(2024, 6, 12),
                  ),
                  firstDate: DateTime(2024, 1, 1),
                  lastDate: DateTime(2024, 12, 31),
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();

    final value = await result as DateTimeRange;
    expect(value.start, DateTime(2024, 6, 10));
    expect(value.end, DateTime(2024, 6, 12));
  });

  testWidgets("calendar highlights today differently from selected date",
      (tester) async {
    final today = DateTime.now();
    final lastDayOfMonth = DateTime(today.year, today.month + 1, 0).day;
    final selected = today.day == lastDayOfMonth
        ? today.subtract(const Duration(days: 1))
        : today.add(const Duration(days: 1));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.calendar(
                  context,
                  initialDate: selected,
                  firstDate: DateTime(today.year, today.month, 1),
                  lastDate: DateTime(today.year, today.month + 1, 0),
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    final todayBackground =
        BottomPickerTheme.defaults.checkedColor.withAlpha((255 * 0.12).round());
    final hasSelectedHighlight = tester
        .widgetList<Container>(find.byType(Container))
        .where((widget) => widget.decoration is BoxDecoration)
        .map((widget) => widget.decoration as BoxDecoration)
        .any((decoration) =>
            decoration.color == BottomPickerTheme.defaults.checkedColor &&
            decoration.shape == BoxShape.circle &&
            decoration.border == null);
    final hasTodayHighlight = tester
        .widgetList<Container>(find.byType(Container))
        .where((widget) => widget.decoration is BoxDecoration)
        .map((widget) => widget.decoration as BoxDecoration)
        .any((decoration) =>
            decoration.color == todayBackground &&
            decoration.shape == BoxShape.circle &&
            decoration.border == null);
    final hasTodayBorder = tester
        .widgetList<Container>(find.byType(Container))
        .where((widget) => widget.decoration is BoxDecoration)
        .map((widget) => widget.decoration as BoxDecoration)
        .any((decoration) =>
            decoration.border is Border &&
            (decoration.border as Border).top.color ==
                BottomPickerTheme.defaults.checkedColor
                    .withAlpha((255 * 0.65).round()));

    expect(hasSelectedHighlight, true);
    expect(hasTodayHighlight, true);
    expect(hasTodayBorder, false);
  });

  testWidgets("year month picker returns selected year month", (tester) async {
    Future<dynamic>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                result = BottomSheetPickers.yearMonth(
                  context,
                  initialYearMonth: const YearMonth(2024, 6),
                  firstYearMonth: const YearMonth(2020, 1),
                  lastYearMonth: const YearMonth(2030, 12),
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.text("2024-06"), findsOneWidget);
    expect(find.byType(CupertinoPicker), findsNWidgets(2));

    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();

    expect(await result, const YearMonth(2024, 6));
  });

  testWidgets("year month range picker returns selected range", (tester) async {
    Future<dynamic>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                result = BottomSheetPickers.yearMonth(
                  context,
                  initialYearMonthRange: YearMonthRange(
                    start: const YearMonth(2024, 6),
                    end: const YearMonth(2024, 8),
                  ),
                  firstYearMonth: const YearMonth(2020, 1),
                  lastYearMonth: const YearMonth(2030, 12),
                  isRange: true,
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.text("2024-06"), findsOneWidget);
    expect(find.text("2024-08"), findsOneWidget);

    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();

    final value = await result as YearMonthRange;
    expect(value.start, const YearMonth(2024, 6));
    expect(value.end, const YearMonth(2024, 8));
  });

  testWidgets("year month range keeps end empty without initial range",
      (tester) async {
    final now = DateTime.now();
    final currentYearMonth =
        "${now.year}-${now.month < 10 ? "0${now.month}" : now.month}";

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.yearMonth(
                  context,
                  firstYearMonth: const YearMonth(2020, 1),
                  lastYearMonth: const YearMonth(2030, 12),
                  isRange: true,
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    expect(find.text(currentYearMonth), findsOneWidget);
    expect(
        tester
            .widget<ElevatedButton>(
                find.widgetWithText(ElevatedButton, "Confirm"))
            .onPressed,
        isNull);
  });

  testWidgets("year month range end candidates start from selected start month",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.yearMonth(
                  context,
                  initialYearMonthRange: YearMonthRange(
                    start: const YearMonth(2026, 7),
                    end: const YearMonth(2026, 9),
                  ),
                  firstYearMonth: const YearMonth(2020, 1),
                  lastYearMonth: const YearMonth(2030, 12),
                  isRange: true,
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("2026-09"));
    await tester.pumpAndSettle();

    expect(find.text("2025"), findsNothing);
    expect(find.text("06"), findsNothing);
    expect(find.text("07"), findsOneWidget);
  });

  testWidgets("year month range start candidates ignore selected end",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.yearMonth(
                  context,
                  initialYearMonthRange: YearMonthRange(
                    start: const YearMonth(2026, 7),
                    end: const YearMonth(2026, 9),
                  ),
                  firstYearMonth: const YearMonth(2020, 1),
                  lastYearMonth: const YearMonth(2030, 12),
                  isRange: true,
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("2026-07"));
    await tester.pumpAndSettle();

    expect(find.text("2027"), findsOneWidget);
  });

  testWidgets("year month range clears end when start moves after end",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.yearMonth(
                  context,
                  initialYearMonthRange: YearMonthRange(
                    start: const YearMonth(2026, 7),
                    end: const YearMonth(2026, 9),
                  ),
                  firstYearMonth: const YearMonth(2026, 1),
                  lastYearMonth: const YearMonth(2027, 12),
                  isRange: true,
                ).show();
              },
              child: const Text("open"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("2026-07"));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CupertinoPicker).first, const Offset(0, -40));
    await tester.pumpAndSettle();

    expect(find.text("2026-09"), findsNothing);
    expect(
        tester
            .widget<ElevatedButton>(
                find.widgetWithText(ElevatedButton, "Confirm"))
            .onPressed,
        isNull);
  });
}
