part of flutter_bottom_sheet_pickers.src;

class CalendarPickerContent extends StatefulWidget {
  final String? title;
  final _BottomSheetCalendarMode mode;
  final CalendarType calendarType;
  final bool isCalendarTypeSpecified;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialDate;
  final DateTimeRange? initialDateRange;
  final BottomPickerTheme themeData;
  final BottomPickerLocalizations? texts;
  final BottomPickerLocalizationBuilder? textsBuilder;

  const CalendarPickerContent({
    this.title,
    required this.mode,
    this.calendarType = CalendarType.gregorian,
    this.isCalendarTypeSpecified = false,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.initialDateRange,
    this.themeData = BottomPickerTheme.defaults,
    this.texts,
    this.textsBuilder,
  });

  @override
  State<CalendarPickerContent> createState() => _CalendarPickerContentState();
}

class _CalendarPickerContentState extends State<CalendarPickerContent> {
  late DateTime _visibleMonth;
  DateTime? _selectedDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  bool get _isConfirmEnabled {
    if (widget.mode == _BottomSheetCalendarMode.date) {
      return _selectedDate != null;
    }
    return _rangeStart != null && _rangeEnd != null;
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = _dateOnly(widget.initialDate);
    _rangeStart = _dateOnly(widget.initialDateRange?.start);
    _rangeEnd = _dateOnly(widget.initialDateRange?.end);
    final initial = _selectedDate ?? _rangeStart ?? DateTime.now();
    final clamped = _clampDate(_dateOnly(initial)!);
    _visibleMonth = DateTime(clamped.year, clamped.month);
  }

  DateTime? _dateOnly(DateTime? date) {
    if (date == null) {
      return null;
    }
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _clampDate(DateTime date) {
    final first = _dateOnly(widget.firstDate)!;
    final last = _dateOnly(widget.lastDate)!;
    if (date.isBefore(first)) {
      return first;
    }
    if (date.isAfter(last)) {
      return last;
    }
    return date;
  }

  bool _sameDate(DateTime? left, DateTime? right) {
    return left != null &&
        right != null &&
        left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  bool _isDisabled(DateTime date) {
    return date.isBefore(_dateOnly(widget.firstDate)!) ||
        date.isAfter(_dateOnly(widget.lastDate)!);
  }

  bool _isInRange(DateTime date) {
    if (_rangeStart == null || _rangeEnd == null) {
      return false;
    }
    return !date.isBefore(_rangeStart!) && !date.isAfter(_rangeEnd!);
  }

  void _tapDate(DateTime date) {
    if (_isDisabled(date)) {
      return;
    }
    setState(() {
      if (widget.mode == _BottomSheetCalendarMode.date) {
        _selectedDate = date;
        return;
      }
      if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
        _rangeStart = date;
        _rangeEnd = null;
      } else if (date.isBefore(_rangeStart!)) {
        _rangeEnd = _rangeStart;
        _rangeStart = date;
      } else {
        _rangeEnd = date;
      }
    });
  }

  void _previousMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  void _previousYear() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year - 1, _visibleMonth.month);
    });
  }

  void _nextYear() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year + 1, _visibleMonth.month);
    });
  }

  DateTime _monthOnly(DateTime date) {
    return DateTime(date.year, date.month);
  }

  bool _canGoPrevious() {
    final previous = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    final firstMonth = _monthOnly(widget.firstDate);
    return !previous.isBefore(firstMonth);
  }

  bool _canGoNext() {
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    final lastMonth = _monthOnly(widget.lastDate);
    return !next.isAfter(lastMonth);
  }

  bool _canGoPreviousYear() {
    final previous = DateTime(_visibleMonth.year - 1, _visibleMonth.month);
    final firstMonth = _monthOnly(widget.firstDate);
    return !previous.isBefore(firstMonth);
  }

  bool _canGoNextYear() {
    final next = DateTime(_visibleMonth.year + 1, _visibleMonth.month);
    final lastMonth = _monthOnly(widget.lastDate);
    return !next.isAfter(lastMonth);
  }

  Object? _result() {
    if (widget.mode == _BottomSheetCalendarMode.date) {
      return _selectedDate;
    }
    if (_rangeStart == null || _rangeEnd == null) {
      return null;
    }
    return DateTimeRange(start: _rangeStart!, end: _rangeEnd!);
  }

  List<DateTime> _monthDays(BottomPickerLocalizations texts) {
    final firstDayOfWeekIndex = texts.firstDayOfWeekIndex;
    final firstDay = DateTime(_visibleMonth.year, _visibleMonth.month);
    final firstDayIndex = firstDay.weekday % DateTime.daysPerWeek;
    final daysBefore =
        (firstDayIndex - firstDayOfWeekIndex) % DateTime.daysPerWeek;
    final start = firstDay.subtract(Duration(days: daysBefore));
    final lastDay = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0);
    final lastDayIndex = lastDay.weekday % DateTime.daysPerWeek;
    final daysAfter =
        (firstDayOfWeekIndex - lastDayIndex - 1) % DateTime.daysPerWeek;
    final end = lastDay.add(Duration(days: daysAfter));
    final dayCount = end.difference(start).inDays + 1;
    return List<DateTime>.generate(
        dayCount, (index) => start.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final texts = BottomPickerLocalizations.resolve(context,
        texts: widget.texts, textsBuilder: widget.textsBuilder);
    return Padding(
      padding: EdgeInsets.only(top: mediaQuery.size.height * 0.12),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        child: Container(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: mediaQuery.size.height * 0.88,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1E5EE),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  if (widget.title != null && widget.title!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                      child: Text(
                        widget.title!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  if (widget.title != null && widget.title!.isNotEmpty)
                    Divider(height: 1, color: Color(0xFFEFF0F6)),
                  _buildHeader(texts),
                  _buildWeekdays(texts),
                  _buildDays(texts),
                  _buildFooter(texts),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BottomPickerLocalizations texts) {
    final calendarName = texts.calendarNames[widget.calendarType] ??
        BottomPickerLocalizations.en.calendarNames[widget.calendarType] ??
        widget.calendarType.name;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(
        children: [
          if (_canGoPreviousYear())
            IconButton(
              onPressed: _previousYear,
              icon: const Icon(Icons.keyboard_double_arrow_left),
            ),
          if (_canGoPrevious())
            IconButton(
              onPressed: _previousMonth,
              icon: const Icon(Icons.chevron_left),
            ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _gregorianMonthLabel(_visibleMonth),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF262626),
                  ),
                ),
                if (widget.calendarType != CalendarType.gregorian)
                  const SizedBox(height: 2),
                if (widget.calendarType != CalendarType.gregorian)
                  Text(
                    calendarName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A94A6),
                    ),
                  ),
              ],
            ),
          ),
          if (_canGoNext())
            IconButton(
              onPressed: _nextMonth,
              icon: const Icon(Icons.chevron_right),
            ),
          if (_canGoNextYear())
            IconButton(
              onPressed: _nextYear,
              icon: const Icon(Icons.keyboard_double_arrow_right),
            ),
        ],
      ),
    );
  }

  String _gregorianMonthLabel(DateTime date) {
    final month = date.month < 10 ? "0${date.month}" : "${date.month}";
    return "${date.year}-$month";
  }

  Widget _buildWeekdays(BottomPickerLocalizations texts) {
    final weekdays = <String>[];
    for (int i = texts.firstDayOfWeekIndex;
        weekdays.length < DateTime.daysPerWeek;
        i = (i + 1) % DateTime.daysPerWeek) {
      weekdays.add(texts.narrowWeekdays[i]);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: weekdays
            .map((item) => Expanded(
                  child: Center(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8A94A6),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDays(BottomPickerLocalizations texts) {
    final days = _monthDays(texts);
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth - 32;
        final tileWidth = (contentWidth - 24) / 7;
        final cellExtent = tileWidth.clamp(36.0, 46.0).toDouble();
        final rowCount = days.length ~/ DateTime.daysPerWeek;
        return SizedBox(
          height: cellExtent * rowCount + (rowCount - 1) * 4 + 30,
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: tileWidth / cellExtent,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              final isCurrentMonth = date.month == _visibleMonth.month;
              final disabled = !isCurrentMonth || _isDisabled(date);
              final selected = widget.mode == _BottomSheetCalendarMode.date
                  ? _sameDate(_selectedDate, date)
                  : _sameDate(_rangeStart, date) || _sameDate(_rangeEnd, date);
              final inRange =
                  widget.mode == _BottomSheetCalendarMode.dateRange &&
                      _isInRange(date);
              final today = _sameDate(date, DateTime.now());
              return _buildDayCell(
                  date, disabled, selected, inRange, today, texts);
            },
          ),
        );
      },
    );
  }

  Widget _buildDayCell(DateTime date, bool disabled, bool selected,
      bool inRange, bool today, BottomPickerLocalizations texts) {
    final showDayLabel = _shouldShowDayLabel();
    final parts = showDayLabel
        ? _CalendarConverter.convert(date, widget.calendarType, texts)
        : null;
    final showToday = today && !disabled;
    final color = disabled
        ? const Color(0xFFCDD3DF)
        : selected
            ? Colors.white
            : showToday
                ? const Color(0xFFFF4D4F)
                : const Color(0xFF262626);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: disabled ? null : () => _tapDate(date),
      child: Container(
        decoration: BoxDecoration(
          color: inRange && !selected
              ? widget.themeData.selectedOptionBackgroundColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? widget.themeData.checkedColor
                    : showToday
                        ? widget.themeData.checkedColor
                            .withAlpha((255 * 0.12).round())
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
              ),
            ),
            if (showDayLabel) const SizedBox(height: 1),
            if (showDayLabel)
              Text(
                _dayCellLabel(parts!),
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 9,
                  color: selected
                      ? widget.themeData.checkedColor
                      : disabled
                          ? const Color(0xFFCDD3DF)
                          : const Color(0xFF8A94A6),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _shouldShowDayLabel() {
    return widget.isCalendarTypeSpecified &&
        widget.calendarType != CalendarType.gregorian;
  }

  String _dayCellLabel(_CalendarParts parts) {
    return parts.day == 1 ? parts.monthLabel : parts.dayLabel;
  }

  Widget _buildFooter(BottomPickerLocalizations texts) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        mediaQuery.padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFEFF0F6)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: widget.themeData.buttonBorderColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: widget.themeData.buttonBorderRadius,
                  ),
                ),
                child: Text(
                  texts.cancel,
                  style: TextStyle(
                    fontSize: 15,
                    color: widget.themeData.buttonBorderColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: !_isConfirmEnabled
                    ? null
                    : () => Navigator.of(context).pop(_result()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.themeData.buttonBackgroundColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: widget.themeData.buttonBorderRadius,
                  ),
                  disabledBackgroundColor:
                      widget.themeData.disabledButtonBackgroundColor,
                  disabledForegroundColor: Colors.white,
                  disabledMouseCursor: SystemMouseCursors.forbidden,
                ),
                child: Text(
                  texts.confirm,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
