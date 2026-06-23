import 'package:flutter/material.dart';
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
    expect(themeData.selectedOptionBackgroundColor, const Color(0xFF1677FF).withAlpha((255 * 0.05).round()));
    expect(themeData.buttonBorderRadius, const BorderRadius.all(Radius.circular(24)));
  });

  test("theme data supports custom button border radius", () {
    const themeData = BottomPickerTheme(
      primaryColor: Color(0xFF1677FF),
      buttonBorderRadius: BorderRadius.all(Radius.circular(12)),
    );

    expect(themeData.buttonBorderRadius, const BorderRadius.all(Radius.circular(12)));
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
    expect(BottomPickerLocalizations.byLocale(const Locale.fromSubtags(languageCode: "zh", scriptCode: "Hant")).confirm, "確認");
    expect(BottomPickerLocalizations.byLocale(const Locale("en")).cancel, "Cancel");
    expect(BottomPickerLocalizations.byLocale(const Locale("th")).cancel, "ยกเลิก");
    expect(BottomPickerLocalizations.byLocale(const Locale("my")).cancel, "ပယ်ဖျက်");
    expect(BottomPickerLocalizations.byLocale(const Locale("pt", "BR")).confirm, "Confirmar");
    expect(BottomPickerLocalizations.byLocale(const Locale("fr", "CA")).reset, "Réinit.");
    expect(BottomPickerLocalizations.byLocale(const Locale("fr", "CA")).searchPlaceholder, "Rechercher");
    expect(BottomPickerLocalizations.byLocale(const Locale("it")).reset, "Reset");
    expect(BottomPickerLocalizations.byLocale(const Locale("it")).noMoreData, "Nessun dato in più");
    expect(BottomPickerLocalizations.byLocale(const Locale("es")).empty, "No hay datos");
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

    expect(dynamicConfig?.localizationBuilder?.call(tester.element(find.byType(SizedBox))).cancel, "Cancel");
  });

  testWidgets("picker global localizations support utility calls", (tester) async {
    late BottomPickerLocalizations fixedTexts;
    late BottomPickerLocalizations dynamicTexts;

    BottomSheetPickers.setLocalizations(localizations: BottomPickerLocalizations.zh);
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

    BottomSheetPickers.setLocalizations(builder: (context) => BottomPickerLocalizations.en);
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

  testWidgets("picker local config overrides global localizations", (tester) async {
    late BottomPickerLocalizations texts;

    BottomSheetPickers.setLocalizations(localizations: BottomPickerLocalizations.en);
    await tester.pumpWidget(
      BottomPickerConfig(
        localizations: BottomPickerLocalizations.zh,
        child: Builder(
          builder: (context) {
            final config = BottomPickerConfig.maybeOf(context);
            texts = BottomPickerLocalizations.resolve(context, texts: config?.localizations, textsBuilder: config?.localizationBuilder);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(texts.cancel, "取消");

    BottomSheetPickers.clearLocalizations();
  });

  testWidgets("picker localizations fill optional labels from current locale", (tester) async {
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

  testWidgets("picker localizations fill optional labels from app locale when app locale is supported", (tester) async {
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

  testWidgets("picker built-in localizations fall back per optional label", (tester) async {
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

  testWidgets("cascade single dismisses when tapping outside visible sheet", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                BottomSheetPickers.cascade(context)
                    .options(const [
                      CascadeOption(id: "1", label: "Level 1"),
                    ])
                    .show();
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
}
