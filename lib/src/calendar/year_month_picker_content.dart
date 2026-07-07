part of flutter_bottom_sheet_pickers.src;

class YearMonthPickerContent extends StatefulWidget {
  final String? title;
  final CalendarType calendarType;
  final YearMonth firstYearMonth;
  final YearMonth lastYearMonth;
  final YearMonth? initialYearMonth;
  final YearMonthRange? initialYearMonthRange;
  final bool isRange;
  final BottomPickerTheme themeData;
  final BottomPickerLocalizations? texts;
  final BottomPickerLocalizationBuilder? textsBuilder;

  const YearMonthPickerContent({
    this.title,
    this.calendarType = CalendarType.gregorian,
    required this.firstYearMonth,
    required this.lastYearMonth,
    this.initialYearMonth,
    this.initialYearMonthRange,
    this.isRange = false,
    this.themeData = BottomPickerTheme.defaults,
    this.texts,
    this.textsBuilder,
  });

  @override
  State<YearMonthPickerContent> createState() => _YearMonthPickerContentState();
}

class _YearMonthPickerContentState extends State<YearMonthPickerContent> {
  late YearMonth _selectedYearMonth;
  late YearMonth _rangeStart;
  YearMonth? _rangeEnd;
  late FixedExtentScrollController _yearController;
  late FixedExtentScrollController _monthController;
  bool _isEditingEnd = false;

  YearMonth get _activeValue =>
      widget.isRange && _isEditingEnd ? _rangeEnd ?? _rangeStart : _rangeStart;

  YearMonth get _activeFirst {
    if (!widget.isRange) {
      return widget.firstYearMonth;
    }
    return _isEditingEnd ? _rangeStart : widget.firstYearMonth;
  }

  YearMonth get _activeLast {
    if (!widget.isRange) {
      return widget.lastYearMonth;
    }
    return widget.lastYearMonth;
  }

  bool get _isConfirmEnabled {
    if (!widget.isRange) {
      return true;
    }
    return _rangeEnd != null && !_rangeEnd!.isBefore(_rangeStart);
  }

  @override
  void initState() {
    super.initState();
    _selectedYearMonth = _clamp(widget.initialYearMonth ??
        widget.initialYearMonthRange?.start ??
        YearMonth.fromDateTime(DateTime.now()));
    _rangeStart =
        _clamp(widget.initialYearMonthRange?.start ?? _selectedYearMonth);
    _rangeEnd = widget.initialYearMonthRange?.end == null
        ? null
        : _clamp(widget.initialYearMonthRange!.end);
    if (_rangeEnd != null && _rangeEnd!.isBefore(_rangeStart)) {
      _rangeEnd = _rangeStart;
    }
    _yearController = FixedExtentScrollController(
        initialItem: _activeValue.year - _activeFirst.year);
    _monthController = FixedExtentScrollController(
        initialItem: _activeValue.month - _firstMonthOf(_activeValue.year));
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  YearMonth _clamp(YearMonth value) {
    if (value.isBefore(widget.firstYearMonth)) {
      return widget.firstYearMonth;
    }
    if (value.isAfter(widget.lastYearMonth)) {
      return widget.lastYearMonth;
    }
    return value;
  }

  String _format(YearMonth value, BottomPickerLocalizations texts) {
    final parts = _CalendarConverter.convert(
        DateTime(value.year, value.month), widget.calendarType, texts);
    return "${parts.year}-${value.month < 10 ? "0${value.month}" : value.month}";
  }

  String _yearLabel(int year, BottomPickerLocalizations texts) {
    final parts = _CalendarConverter.convert(
        DateTime(year, 1), widget.calendarType, texts);
    return "${parts.year}";
  }

  String _monthLabel(int month) {
    return month < 10 ? "0$month" : "$month";
  }

  void _syncControllers() {
    final active = _activeValue;
    final first = _activeFirst;
    final monthStart = _firstMonthOf(active.year);
    _yearController.jumpToItem(active.year - first.year);
    _monthController.jumpToItem(active.month - monthStart);
  }

  void _scheduleSyncControllers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _syncControllers();
      }
    });
  }

  void _selectStart() {
    if (!widget.isRange || !_isEditingEnd) {
      return;
    }
    setState(() {
      _isEditingEnd = false;
    });
    _scheduleSyncControllers();
  }

  void _selectEnd() {
    if (!widget.isRange || _isEditingEnd) {
      return;
    }
    setState(() {
      _isEditingEnd = true;
      if (_rangeEnd != null && _rangeEnd!.isBefore(_rangeStart)) {
        _rangeEnd = _rangeStart;
      }
    });
    _scheduleSyncControllers();
  }

  void _setActiveValue(YearMonth value) {
    final clamped = _clampActive(value);
    setState(() {
      if (!widget.isRange) {
        _selectedYearMonth = clamped;
        _rangeStart = clamped;
        _rangeEnd = clamped;
        return;
      }
      if (_isEditingEnd) {
        _rangeEnd = clamped.isBefore(_rangeStart) ? _rangeStart : clamped;
      } else {
        _rangeStart = clamped;
        if (_rangeEnd != null && _rangeEnd!.isBefore(_rangeStart)) {
          _rangeEnd = null;
        }
      }
    });
    if (widget.isRange || clamped != value) {
      _scheduleSyncControllers();
    }
  }

  YearMonth _clampActive(YearMonth value) {
    final first = _activeFirst;
    final last = _activeLast;
    if (value.isBefore(first)) {
      return first;
    }
    if (value.isAfter(last)) {
      return last;
    }
    return value;
  }

  int _firstMonthOf(int year) {
    final first = _activeFirst;
    return year == first.year ? first.month : 1;
  }

  int _lastMonthOf(int year) {
    final last = _activeLast;
    return year == last.year ? last.month : 12;
  }

  Object _result() {
    if (!widget.isRange) {
      return _selectedYearMonth;
    }
    return YearMonthRange(start: _rangeStart, end: _rangeEnd!);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final texts = BottomPickerLocalizations.resolve(context,
        texts: widget.texts, textsBuilder: widget.textsBuilder);
    return Padding(
      padding: EdgeInsets.only(top: mediaQuery.size.height * 0.15),
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
                  _buildSelectedArea(texts),
                  _buildPickers(texts),
                  _buildFooter(texts),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedArea(BottomPickerLocalizations texts) {
    if (!widget.isRange) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
        child: Text(
          _format(_selectedYearMonth, texts),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: widget.themeData.checkedColor,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 112,
              child: _buildSelectedItem(
                _format(_rangeStart, texts),
                !_isEditingEnd,
                _selectStart,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "-",
              style: TextStyle(fontSize: 18, color: Color(0xFF8A94A6)),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 112,
              child: _buildSelectedItem(
                _rangeEnd == null ? "" : _format(_rangeEnd!, texts),
                _isEditingEnd,
                _selectEnd,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedItem(String text, bool selected, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? widget.themeData.selectedOptionBackgroundColor
              : const Color(0x0D000000),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? widget.themeData.checkedColor
                : const Color(0xFFE1E5EE),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? widget.themeData.checkedColor
                : const Color(0xFF262626),
          ),
        ),
      ),
    );
  }

  Widget _buildPickers(BottomPickerLocalizations texts) {
    return Center(
      child: SizedBox(
        width: 260,
        height: 260,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildYearPicker(texts)),
            Expanded(child: _buildMonthPicker()),
          ],
        ),
      ),
    );
  }

  Widget _buildYearPicker(BottomPickerLocalizations texts) {
    final first = _activeFirst;
    final last = _activeLast;
    final yearCount = last.year - first.year + 1;
    return CupertinoPicker(
      scrollController: _yearController,
      itemExtent: 35,
      selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
      onSelectedItemChanged: (index) {
        _setActiveValue(YearMonth(first.year + index, _activeValue.month));
      },
      children: List<Widget>.generate(
        yearCount,
        (index) => Center(
          child: Text(
            _yearLabel(first.year + index, texts),
            style: const TextStyle(fontSize: 18, color: Color(0xFF262626)),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthPicker() {
    final monthStart = _firstMonthOf(_activeValue.year);
    final monthEnd = _lastMonthOf(_activeValue.year);
    final monthCount = monthEnd - monthStart + 1;
    return CupertinoPicker(
      scrollController: _monthController,
      itemExtent: 35,
      selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
      onSelectedItemChanged: (index) {
        _setActiveValue(YearMonth(_activeValue.year, monthStart + index));
      },
      children: List<Widget>.generate(
        monthCount,
        (index) => Center(
          child: Text(
            _monthLabel(monthStart + index),
            style: const TextStyle(fontSize: 18, color: Color(0xFF262626)),
          ),
        ),
      ),
    );
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
