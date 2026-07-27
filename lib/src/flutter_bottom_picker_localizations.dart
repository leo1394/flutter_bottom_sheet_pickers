part of flutter_bottom_sheet_pickers.src;

/// Text labels used by bottom sheet pickers.
///
/// All constructor parameters are optional. Missing labels are filled from the
/// current locale when [resolve] is called.
class BottomPickerLocalizations {
  final String? _cancel;
  final String? _reset;
  final String? _confirm;
  final String? _noData;

  /// Text for the cancel action.
  String get cancel => _cancel ?? BottomPickerLocalizations.en.cancel;

  /// Text for the reset action.
  String get reset => _reset ?? BottomPickerLocalizations.en.reset;

  /// Text for the confirm action.
  String get confirm => _confirm ?? BottomPickerLocalizations.en.confirm;

  /// Text for empty data states.
  String get noData => _noData ?? BottomPickerLocalizations.en.noData;

  final String? _loadingText;
  final String? _empty;
  final String? _noMoreData;
  final String? _all;
  final String? _searchPlaceholder;
  final String? _selectedCount;
  final Map<CalendarType, String>? _calendarNames;
  final List<String>? _lunarMonths;
  final List<String>? _lunarDays;
  final List<String>? _hebrewMonths;
  final List<String>? _narrowWeekdays;
  final int? _firstDayOfWeekIndex;

  /// Text shown while lazy data is loading.
  String get loadingText =>
      _loadingText ?? BottomPickerLocalizations.en.loadingText;

  /// Text for generic empty states.
  String get empty => _empty ?? BottomPickerLocalizations.en.empty;

  /// Text shown after all lazy data has loaded.
  String get noMoreData =>
      _noMoreData ?? BottomPickerLocalizations.en.noMoreData;

  /// Text for cascade "all" options.
  String get all => _all ?? BottomPickerLocalizations.en.all;

  /// Placeholder used by the search input.
  String get searchPlaceholder =>
      _searchPlaceholder ?? BottomPickerLocalizations.en.searchPlaceholder;

  /// Text shown for selected item count. Use `{count}` as the count token.
  String selectedCountText(int count) {
    final template = _selectedCount ??
        BottomPickerLocalizations.en._selectedCount ??
        "{count}";
    return template.replaceAll("{count}", count.toString());
  }

  /// Display names for supported calendar systems.
  Map<CalendarType, String> get calendarNames =>
      _calendarNames ?? BottomPickerLocalizations.en.calendarNames;

  /// Month labels used by Chinese lunar calendar display.
  List<String> get lunarMonths =>
      _lunarMonths ?? BottomPickerLocalizations.en.lunarMonths;

  /// Day labels used by Chinese lunar calendar display.
  List<String> get lunarDays =>
      _lunarDays ?? BottomPickerLocalizations.en.lunarDays;

  /// Month labels used by Hebrew calendar display.
  List<String> get hebrewMonths =>
      _hebrewMonths ?? BottomPickerLocalizations.en.hebrewMonths;

  /// Narrow weekday labels ordered from Sunday to Saturday.
  List<String> get narrowWeekdays =>
      _narrowWeekdays ?? BottomPickerLocalizations.en.narrowWeekdays;

  /// First day of week index, where 0 is Sunday and 6 is Saturday.
  int get firstDayOfWeekIndex =>
      _firstDayOfWeekIndex ?? BottomPickerLocalizations.en.firstDayOfWeekIndex;

  /// Creates picker texts.
  ///
  /// Provide only the labels that need to be overridden. Unset labels fall back
  /// to the built-in labels selected for the active locale.
  const BottomPickerLocalizations({
    String? cancel,
    String? reset,
    String? confirm,
    String? noData,
    String? loadingText,
    String? empty,
    String? noMoreData,
    String? all,
    String? searchPlaceholder,
    String? selectedCount,
    Map<CalendarType, String>? calendarNames,
    List<String>? lunarMonths,
    List<String>? lunarDays,
    List<String>? hebrewMonths,
    List<String>? narrowWeekdays,
    int? firstDayOfWeekIndex,
  })  : _cancel = cancel,
        _reset = reset,
        _confirm = confirm,
        _noData = noData,
        _loadingText = loadingText,
        _empty = empty,
        _noMoreData = noMoreData,
        _all = all,
        _searchPlaceholder = searchPlaceholder,
        _selectedCount = selectedCount,
        _calendarNames = calendarNames,
        _lunarMonths = lunarMonths,
        _lunarDays = lunarDays,
        _hebrewMonths = hebrewMonths,
        _narrowWeekdays = narrowWeekdays,
        _firstDayOfWeekIndex = firstDayOfWeekIndex;

  /// Built-in English labels.
  static const BottomPickerLocalizations en = BuiltInLocalizations.en;

  /// Built-in simplified Chinese labels.
  static const BottomPickerLocalizations zh = BuiltInLocalizations.zh;

  /// Built-in traditional Chinese labels.
  static const BottomPickerLocalizations zhHant = BuiltInLocalizations.zhHant;

  /// Built-in Thai labels.
  static const BottomPickerLocalizations th = BuiltInLocalizations.th;

  /// Built-in Burmese labels.
  static const BottomPickerLocalizations my = BuiltInLocalizations.my;

  /// Built-in Brazilian Portuguese labels.
  static const BottomPickerLocalizations ptBR = BuiltInLocalizations.ptBR;

  /// Built-in Canadian French labels.
  static const BottomPickerLocalizations frCA = BuiltInLocalizations.frCA;

  /// Built-in Italian labels.
  static const BottomPickerLocalizations it = BuiltInLocalizations.it;

  /// Built-in Spanish labels.
  static const BottomPickerLocalizations es = BuiltInLocalizations.es;

  /// Resolves built-in labels from a locale and falls back to English.
  ///
  /// Chinese locales with script `Hant` or region `TW`, `HK`, or `MO` resolve
  /// to [zhHant]. Portuguese resolves to [ptBR], and French resolves to [frCA].
  static BottomPickerLocalizations byLocale(Locale? locale) {
    return BuiltInLocalizations.byLocale(locale);
  }

  static bool _isSupported(Locale? locale) {
    return BuiltInLocalizations.isSupported(locale);
  }

  static BottomPickerLocalizations _fallbackForContext(BuildContext context) {
    final locale = Localizations.maybeLocaleOf(context);
    if (_isSupported(locale)) {
      return BottomPickerLocalizations.byLocale(locale);
    }
    final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
    if (_isSupported(platformLocale)) {
      return BottomPickerLocalizations.byLocale(platformLocale);
    }
    return BottomPickerLocalizations.en;
  }

  static BottomPickerLocalizations _fallbackForResolved(
      BottomPickerLocalizations resolved,
      BottomPickerLocalizations contextFallback) {
    final builtIns = [
      BottomPickerLocalizations.en,
      BottomPickerLocalizations.zh,
      BottomPickerLocalizations.zhHant,
      BottomPickerLocalizations.th,
      BottomPickerLocalizations.my,
      BottomPickerLocalizations.ptBR,
      BottomPickerLocalizations.frCA,
      BottomPickerLocalizations.it,
      BottomPickerLocalizations.es,
    ];
    BottomPickerLocalizations? bestMatch;
    int bestScore = 0;
    for (final item in builtIns) {
      int score = 0;
      if (resolved._cancel != null && resolved._cancel == item.cancel) {
        score++;
      }
      if (resolved._reset != null && resolved._reset == item.reset) {
        score++;
      }
      if (resolved._confirm != null && resolved._confirm == item.confirm) {
        score++;
      }
      if (resolved._noData != null && resolved._noData == item.noData) {
        score++;
      }
      if (resolved._loadingText != null &&
          resolved._loadingText == item.loadingText) {
        score++;
      }
      if (resolved._empty != null && resolved._empty == item.empty) {
        score++;
      }
      if (resolved._noMoreData != null &&
          resolved._noMoreData == item.noMoreData) {
        score++;
      }
      if (resolved._all != null && resolved._all == item.all) {
        score++;
      }
      if (resolved._searchPlaceholder != null &&
          resolved._searchPlaceholder == item.searchPlaceholder) {
        score++;
      }
      if (resolved._selectedCount != null &&
          resolved.selectedCountText(1) == item.selectedCountText(1)) {
        score++;
      }
      if (score > bestScore) {
        bestScore = score;
        bestMatch = item;
      }
    }
    return bestMatch ?? contextFallback;
  }

  /// Fills optional labels with labels from [fallback].
  ///
  /// This lets apps override only a few labels while keeping built-in text for
  /// the rest of the picker UI.
  BottomPickerLocalizations mergeWith(BottomPickerLocalizations fallback) {
    return BottomPickerLocalizations(
      cancel: _cancel ?? fallback.cancel,
      reset: _reset ?? fallback.reset,
      confirm: _confirm ?? fallback.confirm,
      noData: _noData ?? fallback.noData,
      loadingText: _loadingText ?? fallback.loadingText,
      empty: _empty ?? fallback.empty,
      noMoreData: _noMoreData ?? fallback.noMoreData,
      all: _all ?? fallback.all,
      searchPlaceholder: _searchPlaceholder ?? fallback.searchPlaceholder,
      selectedCount: _selectedCount ?? fallback._selectedCount,
      calendarNames: _calendarNames ?? fallback.calendarNames,
      lunarMonths: _lunarMonths ?? fallback.lunarMonths,
      lunarDays: _lunarDays ?? fallback.lunarDays,
      hebrewMonths: _hebrewMonths ?? fallback.hebrewMonths,
      narrowWeekdays: _narrowWeekdays ?? fallback.narrowWeekdays,
      firstDayOfWeekIndex: _firstDayOfWeekIndex ?? fallback.firstDayOfWeekIndex,
    );
  }

  /// Resolves labels from explicit config, global config, or the current locale.
  ///
  /// Resolution order is:
  ///
  /// 1. [textsBuilder]
  /// 2. [texts]
  /// 3. global labels configured with [BottomSheetPickers.setLocalizations]
  /// 4. built-in labels selected from the current Flutter locale
  /// 5. built-in labels selected from the platform locale
  /// 6. English
  static BottomPickerLocalizations resolve(BuildContext context,
      {BottomPickerLocalizations? texts,
      BottomPickerLocalizationBuilder? textsBuilder}) {
    final fallback = BottomPickerLocalizations._fallbackForContext(context);
    final resolved = textsBuilder?.call(context) ??
        texts ??
        BottomPickerConfig.defaultLocalizationBuilder?.call(context) ??
        BottomPickerConfig.defaultLocalizations;
    return resolved?.mergeWith(_fallbackForResolved(resolved, fallback)) ??
        fallback;
  }
}
