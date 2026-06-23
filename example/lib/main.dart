import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bottom_sheet_pickers/flutter_bottom_sheet_pickers.dart';

void main() {
  runApp(const PickerExampleApp());
}

class PickerExampleApp extends StatefulWidget {
  const PickerExampleApp({super.key});

  @override
  State<PickerExampleApp> createState() => _PickerExampleAppState();
}

class _PickerExampleAppState extends State<PickerExampleApp> {
  Locale _locale = const Locale("en");

  @override
  void initState() {
    super.initState();
    _applyPickerLocalizations(_locale);
  }

  @override
  void dispose() {
    BottomSheetPickers.clearLocalizations();
    super.dispose();
  }

  void _applyPickerLocalizations(Locale locale) {
    BottomSheetPickers.setLocalizations(localizations: BottomPickerLocalizations.byLocale(locale));
  }

  void _toggleLocale() {
    final nextLocale = _locale.languageCode == "en" ? const Locale("zh") : const Locale("en");
    _applyPickerLocalizations(nextLocale);
    setState(() => _locale = nextLocale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Bottom Pickers",
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale("en"),
        Locale("zh"),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1677FF)),
        useMaterial3: true,
      ),
      home: PickerExampleHome(
        locale: _locale,
        onToggleLocale: _toggleLocale,
      ),
    );
  }
}

class PickerExampleHome extends StatefulWidget {
  final Locale locale;
  final VoidCallback onToggleLocale;

  const PickerExampleHome({
    super.key,
    required this.locale,
    required this.onToggleLocale,
  });

  @override
  State<PickerExampleHome> createState() => _PickerExampleHomeState();
}

class _PickerExampleHomeState extends State<PickerExampleHome> {
  String _result = "No selection";
  static const BottomPickerTheme _theme = BottomPickerTheme(
    primaryColor: Color(0xFF1677FF),
    buttonBorderRadius: BorderRadius.all(Radius.circular(16)),
  );

  final List<CascadeOption> _locations = const [
    CascadeOption(
      id: "province_a",
      label: "Province A",
      children: [
        CascadeOption(
          id: "city_a",
          label: "City A",
          children: [
            CascadeOption(id: "town_a", label: "Town A"),
            CascadeOption(id: "town_b", label: "Town B"),
          ],
        ),
        CascadeOption(id: "city_b", label: "City B"),
      ],
    ),
    CascadeOption(
      id: "province_b",
      label: "Province B",
      children: [
        CascadeOption(id: "city_c", label: "City C"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Bottom Pickers"),
        actions: [
          TextButton(
            onPressed: widget.onToggleLocale,
            child: Text(widget.locale.languageCode == "en" ? "中文" : "EN"),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_result, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _showSinglePicker,
            child: const Text("Show single picker"),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _showMultiplePicker,
            child: const Text("Show multiple picker"),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _showCascadePicker,
            child: const Text("Show cascade picker"),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _showMultipleCascadePicker,
            child: const Text("Show multiple cascade picker"),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _showLazyPicker,
            child: const Text("Show lazy picker"),
          ),
        ],
      ),
    );
  }

  Future<void> _showSinglePicker() async {
    final selected = await BottomSheetPickers.single<String>(
      context,
      title: "Choose a fruit",
      themeData: _theme,
    ).options(["Apple", "Orange", "Banana"], initialValue: "Apple").show();
    _updateResult(selected);
  }

  Future<void> _showMultiplePicker() async {
    final selected = await BottomSheetPickers.multiple<String>(
      context,
      title: "Choose tags",
      themeData: _theme,
    ).options(["New", "Popular", "Recommended", "Archived"], initialValue: ["New"]).show();
    _updateResult(selected);
  }

  Future<void> _showCascadePicker() async {
    final selected = await BottomSheetPickers.cascade(
      context,
      title: "Choose location",
      themeData: _theme,
    ).options(_locations)
        .initialValue(CascadeSelection.byIds("province_a", "city_a", "town_a"))
        .cascadeAllItemSupported()
        .show();
    if(selected is CascadeSelection) {
      _updateResult(selected.path.map((item) => item.label).join(" / "));
    }
  }

  Future<void> _showMultipleCascadePicker() async {
    final selected = await BottomSheetPickers.cascade(
      context,
      title: "Choose locations",
      themeData: _theme,
    ).options(_locations)
        .multiple()
        .initialValues([CascadeSelection.byIds("province_a", "city_a", "town_a")])
        .show();
    _updateResult(selected?.map((item) => item.path.map((option) => option.label).join(" / ")).join(", "));
  }

  Future<void> _showLazyPicker() async {
    final selected = await BottomSheetPickers.single<String>(
      context,
      title: "Choose remote item",
      themeData: _theme,
    ).lazyLoad(
      lazyRequestFuture: (params) async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        final int pageIndex = params["page_index"] as int? ?? 1;
        return List<String>.generate(10, (index) => "Item ${(pageIndex - 1) * 10 + index + 1}");
      },
    ).show();
    _updateResult(selected);
  }

  void _updateResult(Object? value) {
    if(!mounted) { return ; }
    setState(() => _result = value?.toString() ?? "Cancelled");
  }
}
