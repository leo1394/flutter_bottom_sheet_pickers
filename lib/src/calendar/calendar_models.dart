part of flutter_bottom_sheet_pickers.src;

/// Calendar systems supported by bottom sheet calendar pickers.
enum CalendarType {
  /// Gregorian calendar.
  gregorian,

  /// Chinese lunar calendar display.
  lunar,

  /// Buddhist calendar display.
  buddhist,

  /// Tibetan calendar display.
  tibetan,

  /// Islamic Hijri calendar display.
  islamic,

  /// Yi calendar display.
  yi,

  /// Hebrew calendar display.
  hebrew,
}

enum _BottomSheetCalendarMode {
  date,
  dateRange,
}

/// A year-month value.
class YearMonth implements Comparable<YearMonth> {
  /// Gregorian year.
  final int year;

  /// Gregorian month from 1 to 12.
  final int month;

  /// Creates a year-month value.
  const YearMonth(this.year, this.month) : assert(month >= 1 && month <= 12);

  /// Creates a year-month value from a [DateTime].
  factory YearMonth.fromDateTime(DateTime date) {
    return YearMonth(date.year, date.month);
  }

  /// Converts this value to the first day of its month.
  DateTime toDateTime() => DateTime(year, month);

  /// Compares by year first and month second.
  @override
  int compareTo(YearMonth other) {
    final yearCompare = year.compareTo(other.year);
    if (yearCompare != 0) {
      return yearCompare;
    }
    return month.compareTo(other.month);
  }

  /// Whether this value is earlier than [other].
  bool isBefore(YearMonth other) => compareTo(other) < 0;

  /// Whether this value is later than [other].
  bool isAfter(YearMonth other) => compareTo(other) > 0;

  @override
  bool operator ==(Object other) {
    return other is YearMonth && other.year == year && other.month == month;
  }

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() {
    final value = month < 10 ? "0$month" : "$month";
    return "$year-$value";
  }
}

/// A year-month range.
class YearMonthRange {
  /// Inclusive start year-month.
  final YearMonth start;

  /// Inclusive end year-month.
  final YearMonth end;

  /// Creates a year-month range.
  ///
  /// The [end] value must not be before [start].
  YearMonthRange({
    required this.start,
    required this.end,
  }) : assert(!end.isBefore(start));

  @override
  String toString() => "$start - $end";
}

class _CalendarParts {
  final int year;
  final int month;
  final int day;
  final String calendarName;
  final String monthLabel;
  final String dayLabel;
  final String fullLabel;

  const _CalendarParts({
    required this.year,
    required this.month,
    required this.day,
    required this.calendarName,
    required this.monthLabel,
    required this.dayLabel,
    required this.fullLabel,
  });
}

class _CalendarConverter {
  static _CalendarParts convert(
      DateTime date, CalendarType type, BottomPickerLocalizations texts) {
    final localDate = DateTime(date.year, date.month, date.day);
    final calendarName = texts.calendarNames[type] ??
        BottomPickerLocalizations.en.calendarNames[type] ??
        type.name;
    switch (type) {
      case CalendarType.gregorian:
        return _parts(
            date: localDate,
            year: localDate.year,
            month: localDate.month,
            day: localDate.day,
            calendarName: calendarName);
      case CalendarType.buddhist:
        return _parts(
            date: localDate,
            year: localDate.year + 543,
            month: localDate.month,
            day: localDate.day,
            calendarName: calendarName);
      case CalendarType.islamic:
        final parts = _islamicFromJulianDay(_julianDay(localDate));
        return _parts(
            date: localDate,
            year: parts[0],
            month: parts[1],
            day: parts[2],
            calendarName: calendarName);
      case CalendarType.hebrew:
        final parts = _hebrewApprox(localDate);
        return _parts(
            date: localDate,
            year: parts[0],
            month: parts[1],
            day: parts[2],
            calendarName: calendarName,
            monthName: texts.hebrewMonths[(parts[1] - 1).clamp(0, 12)]);
      case CalendarType.lunar:
        final parts = _cycleApprox(localDate, DateTime(2024, 2, 10), 1);
        return _parts(
            date: localDate,
            year: parts[0],
            month: parts[1],
            day: parts[2],
            calendarName: calendarName,
            monthName: texts.lunarMonths[(parts[1] - 1).clamp(0, 11)],
            dayName: texts.lunarDays[(parts[2] - 1).clamp(0, 29)]);
      case CalendarType.tibetan:
        final parts = _cycleApprox(localDate, DateTime(2024, 2, 10), 1);
        return _parts(
            date: localDate,
            year: parts[0] + 127,
            month: parts[1],
            day: parts[2],
            calendarName: calendarName);
      case CalendarType.yi:
        final parts = _cycleApprox(localDate, DateTime(2023, 12, 22), 11);
        return _parts(
            date: localDate,
            year: parts[0],
            month: parts[1],
            day: parts[2],
            calendarName: calendarName);
    }
  }

  static _CalendarParts _parts({
    required DateTime date,
    required int year,
    required int month,
    required int day,
    required String calendarName,
    String? monthName,
    String? dayName,
  }) {
    final monthLabel = monthName ?? "$year-${_two(month)}";
    final dayLabel = dayName ?? day.toString();
    final fullLabel = monthName == null && dayName == null
        ? "$year-${_two(month)}-${_two(day)}"
        : "$year $monthLabel $dayLabel";
    return _CalendarParts(
      year: year,
      month: month,
      day: day,
      calendarName: calendarName,
      monthLabel: monthLabel,
      dayLabel: dayLabel,
      fullLabel: fullLabel,
    );
  }

  static String _two(int value) => value < 10 ? "0$value" : "$value";

  static int _julianDay(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    return date.day +
        ((153 * m + 2) ~/ 5) +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }

  static List<int> _islamicFromJulianDay(int julianDay) {
    var l = julianDay - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final month = (24 * l) ~/ 709;
    final day = l - (709 * month) ~/ 24;
    final year = 30 * n + j - 30;
    return [year, month, day];
  }

  static List<int> _hebrewApprox(DateTime date) {
    final roshHashanah = DateTime(date.year, 9, 16);
    final hebrewYear =
        date.isBefore(roshHashanah) ? date.year + 3760 : date.year + 3761;
    final start = date.isBefore(roshHashanah)
        ? DateTime(date.year - 1, 9, 16)
        : roshHashanah;
    final days = date.difference(start).inDays;
    final month = ((days ~/ 30) + 7 - 1) % 13 + 1;
    final day = days % 30 + 1;
    return [hebrewYear, month, day];
  }

  static List<int> _cycleApprox(
      DateTime date, DateTime knownNewYear, int knownMonth) {
    final days = date.difference(knownNewYear).inDays;
    final cycleDay = ((days % 354) + 354) % 354;
    final yearOffset = days >= 0 ? days ~/ 354 : -((-days + 353) ~/ 354);
    final month = ((cycleDay ~/ 29 + knownMonth - 1) % 12) + 1;
    final day = cycleDay % 29 + 1;
    return [knownNewYear.year + yearOffset, month, day];
  }
}
