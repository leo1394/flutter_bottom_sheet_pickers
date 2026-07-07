part of flutter_bottom_sheet_pickers.src;

/// Chainable builder for a single date bottom sheet calendar picker.
class BottomSheetDatePicker {
  final BuildContext _context;
  String? _title;
  CalendarType _calendarType;
  bool _isCalendarTypeSpecified;
  BottomPickerTheme _themeData;
  DateTime? _initialDate;
  DateTime _firstDate = DateTime(1900, 1, 1);
  DateTime _lastDate = DateTime(2100, 12, 31);

  BottomSheetDatePicker._(
    this._context, {
    String? title,
    CalendarType calendarType = CalendarType.gregorian,
    bool isCalendarTypeSpecified = false,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    BottomPickerTheme themeData = BottomPickerTheme.defaults,
  })  : _title = title,
        _calendarType = calendarType,
        _isCalendarTypeSpecified = isCalendarTypeSpecified,
        _themeData = themeData {
    _configure(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  /// Sets the picker title.
  BottomSheetDatePicker title(String? title) {
    _title = title;
    return this;
  }

  /// Sets the display calendar system used for helper labels.
  ///
  /// The month header and selected value remain Gregorian. Non-Gregorian
  /// calendar types show small helper labels inside day cells.
  BottomSheetDatePicker calendarType(CalendarType calendarType) {
    _calendarType = calendarType;
    _isCalendarTypeSpecified = true;
    return this;
  }

  void _configure({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    _initialDate = initialDate;
    if (firstDate != null) {
      _firstDate = DateTime(firstDate.year, firstDate.month, firstDate.day);
    }
    if (lastDate != null) {
      _lastDate = DateTime(lastDate.year, lastDate.month, lastDate.day);
    }
  }

  /// Sets the initially selected date and optional date bounds.
  ///
  /// [firstDate] and [lastDate] are inclusive. Dates outside the range are
  /// disabled, and month/year navigation buttons are only shown when their
  /// target month is inside this range.
  BottomSheetDatePicker init({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    _configure(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    return this;
  }

  /// Shows the calendar and returns the selected date.
  ///
  /// Returns `null` when the sheet is cancelled, dismissed by tapping outside,
  /// or closed with the system back action.
  Future<DateTime?> show() async {
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
                  mode: _BottomSheetCalendarMode.date,
                  calendarType: _calendarType,
                  isCalendarTypeSpecified: _isCalendarTypeSpecified,
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  initialDate: _initialDate,
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
    return result as DateTime?;
  }
}
