part of flutter_bottom_sheet_pickers.src;

/// Chainable builder for a year-month bottom sheet picker.
class BottomSheetYearMonthPicker {
  final BuildContext _context;
  String? _title;
  CalendarType _calendarType;
  BottomPickerTheme _themeData;
  YearMonth? _initialYearMonth;
  YearMonthRange? _initialYearMonthRange;
  YearMonth _firstYearMonth = const YearMonth(1900, 1);
  YearMonth _lastYearMonth = const YearMonth(2100, 12);
  bool _isRange = false;

  BottomSheetYearMonthPicker._(
    this._context, {
    String? title,
    CalendarType calendarType = CalendarType.gregorian,
    YearMonth? initialYearMonth,
    YearMonthRange? initialYearMonthRange,
    YearMonth? firstYearMonth,
    YearMonth? lastYearMonth,
    bool isRange = false,
    BottomPickerTheme themeData = BottomPickerTheme.defaults,
  })  : _title = title,
        _calendarType = calendarType,
        _themeData = themeData {
    _configure(
      initialYearMonth: initialYearMonth,
      initialYearMonthRange: initialYearMonthRange,
      firstYearMonth: firstYearMonth,
      lastYearMonth: lastYearMonth,
      isRange: isRange,
    );
  }

  /// Sets the picker title.
  BottomSheetYearMonthPicker title(String? title) {
    _title = title;
    return this;
  }

  /// Sets the display calendar system used for the year label.
  ///
  /// Month values remain Gregorian month numbers.
  BottomSheetYearMonthPicker calendarType(CalendarType calendarType) {
    _calendarType = calendarType;
    return this;
  }

  void _configure({
    YearMonth? initialYearMonth,
    YearMonthRange? initialYearMonthRange,
    YearMonth? firstYearMonth,
    YearMonth? lastYearMonth,
    bool? isRange,
  }) {
    if (firstYearMonth != null) {
      _firstYearMonth = firstYearMonth;
    }
    if (lastYearMonth != null) {
      _lastYearMonth = lastYearMonth;
    }
    if (initialYearMonth != null) {
      _initialYearMonth = initialYearMonth;
    }
    if (initialYearMonthRange != null) {
      _initialYearMonthRange = initialYearMonthRange;
    }
    if (isRange != null) {
      _isRange = isRange;
    }
  }

  /// Sets the initially selected year-month and optional bounds.
  ///
  /// [firstYearMonth] and [lastYearMonth] are inclusive and control the wheel
  /// candidates.
  BottomSheetYearMonthPicker value({
    YearMonth? initialYearMonth,
    YearMonth? firstYearMonth,
    YearMonth? lastYearMonth,
  }) {
    _configure(
      initialYearMonth: initialYearMonth,
      firstYearMonth: firstYearMonth,
      lastYearMonth: lastYearMonth,
      isRange: false,
    );
    return this;
  }

  /// Enables year-month range selection.
  ///
  /// When [initialYearMonthRange] is omitted, the start defaults to the current
  /// year-month and the end is empty until the user chooses one. While editing
  /// the end value, candidates start from the selected start value.
  BottomSheetYearMonthPicker range({
    YearMonthRange? initialYearMonthRange,
    YearMonth? firstYearMonth,
    YearMonth? lastYearMonth,
  }) {
    _configure(
      initialYearMonthRange: initialYearMonthRange,
      firstYearMonth: firstYearMonth,
      lastYearMonth: lastYearMonth,
      isRange: true,
    );
    return this;
  }

  /// Shows the picker and returns a [YearMonth] or [YearMonthRange].
  ///
  /// The returned type depends on whether range mode is enabled. Returns
  /// `null` when cancelled or dismissed.
  Future<dynamic> show() {
    assert(!_lastYearMonth.isBefore(_firstYearMonth),
        "lastYearMonth must not be before firstYearMonth.");
    final textConfig = BottomPickerConfig.maybeOf(_context);
    return showModalBottomSheet<dynamic>(
      context: _context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(sheetContext).pop(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: YearMonthPickerContent(
                  title: _title,
                  calendarType: _calendarType,
                  firstYearMonth: _firstYearMonth,
                  lastYearMonth: _lastYearMonth,
                  initialYearMonth: _initialYearMonth,
                  initialYearMonthRange: _initialYearMonthRange,
                  isRange: _isRange,
                  themeData: _themeData,
                  texts: textConfig?.localizations,
                  textsBuilder: textConfig?.localizationBuilder,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
