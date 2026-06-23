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
  })  : _cancel = cancel,
        _reset = reset,
        _confirm = confirm,
        _noData = noData,
        _loadingText = loadingText,
        _empty = empty,
        _noMoreData = noMoreData,
        _all = all,
        _searchPlaceholder = searchPlaceholder;

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
    return resolved?.mergeWith(fallback) ?? fallback;
  }
}
