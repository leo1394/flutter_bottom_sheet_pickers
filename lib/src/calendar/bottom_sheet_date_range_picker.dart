part of flutter_bottom_sheet_pickers.src;

/// Chainable builder for a date range bottom sheet calendar picker.
class BottomSheetDateRangePicker {
  final BuildContext _context;
  String? _title;
  CalendarType _calendarType;
  bool _isCalendarTypeSpecified;
  BottomPickerTheme _themeData;
  DateTimeRange? _initialDateRange;
  DateTime _firstDate = DateTime(1900, 1, 1);
  DateTime _lastDate = DateTime(2100, 12, 31);

  BottomSheetDateRangePicker._(
    this._context, {
    String? title,
    CalendarType calendarType = CalendarType.gregorian,
    bool isCalendarTypeSpecified = false,
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    BottomPickerTheme themeData = BottomPickerTheme.defaults,
  })  : _title = title,
        _calendarType = calendarType,
        _isCalendarTypeSpecified = isCalendarTypeSpecified,
        _themeData = themeData {
    _configure(
      initialDateRange: initialDateRange,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  /// Sets the picker title.
  BottomSheetDateRangePicker title(String? title) {
    _title = title;
    return this;
  }

  /// Sets the display calendar system used for helper labels.
  ///
  /// The month header and returned [DateTimeRange] remain Gregorian.
  /// Non-Gregorian calendar types show small helper labels inside day cells.
  BottomSheetDateRangePicker calendarType(CalendarType calendarType) {
    _calendarType = calendarType;
    _isCalendarTypeSpecified = true;
    return this;
  }

  void _configure({
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    _initialDateRange = initialDateRange;
    if (firstDate != null) {
      _firstDate = DateTime(firstDate.year, firstDate.month, firstDate.day);
    }
    if (lastDate != null) {
      _lastDate = DateTime(lastDate.year, lastDate.month, lastDate.day);
    }
  }

  /// Shows the calendar and returns the selected date range.
  ///
  /// [firstDate] and [lastDate] are inclusive bounds. The confirm button stays
  /// disabled until both range endpoints are selected. Returns `null` when the
  /// sheet is cancelled, dismissed by tapping outside, or closed with the
  /// system back action.
  Future<DateTimeRange?> show() async {
    assert(!_lastDate.isBefore(_firstDate),
        "lastDate must not be before firstDate.");
    final textConfig = BottomPickerConfig.maybeOf(_context);
    final result = await showModalBottomSheet<dynamic>(
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
                child: CalendarPickerContent(
                  title: _title,
                  mode: _BottomSheetCalendarMode.dateRange,
                  calendarType: _calendarType,
                  isCalendarTypeSpecified: _isCalendarTypeSpecified,
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  initialDateRange: _initialDateRange,
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
    return result as DateTimeRange?;
  }
}
