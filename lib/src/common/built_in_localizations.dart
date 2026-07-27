part of flutter_bottom_sheet_pickers.src;

/// Built-in text labels resolved from locale.
class BuiltInLocalizations {
  BuiltInLocalizations._();

  static const Map<CalendarType, String> _calendarNamesEn = {
    CalendarType.gregorian: "Gregorian",
    CalendarType.lunar: "Lunar",
    CalendarType.buddhist: "Buddhist",
    CalendarType.tibetan: "Tibetan",
    CalendarType.islamic: "Hijri",
    CalendarType.yi: "Yi",
    CalendarType.hebrew: "Hebrew",
  };

  static const Map<CalendarType, String> _calendarNamesZh = {
    CalendarType.gregorian: "公历",
    CalendarType.lunar: "农历",
    CalendarType.buddhist: "佛历",
    CalendarType.tibetan: "藏历",
    CalendarType.islamic: "伊斯兰历",
    CalendarType.yi: "彝历",
    CalendarType.hebrew: "希伯来历",
  };

  static const Map<CalendarType, String> _calendarNamesZhHant = {
    CalendarType.gregorian: "公曆",
    CalendarType.lunar: "農曆",
    CalendarType.buddhist: "佛曆",
    CalendarType.tibetan: "藏曆",
    CalendarType.islamic: "伊斯蘭曆",
    CalendarType.yi: "彝曆",
    CalendarType.hebrew: "希伯來曆",
  };

  static const List<String> _lunarMonthsZh = [
    "正月",
    "二月",
    "三月",
    "四月",
    "五月",
    "六月",
    "七月",
    "八月",
    "九月",
    "十月",
    "冬月",
    "腊月",
  ];

  static const List<String> _lunarMonthsZhHant = [
    "正月",
    "二月",
    "三月",
    "四月",
    "五月",
    "六月",
    "七月",
    "八月",
    "九月",
    "十月",
    "冬月",
    "臘月",
  ];

  static const List<String> _lunarDaysZh = [
    "初一",
    "初二",
    "初三",
    "初四",
    "初五",
    "初六",
    "初七",
    "初八",
    "初九",
    "初十",
    "十一",
    "十二",
    "十三",
    "十四",
    "十五",
    "十六",
    "十七",
    "十八",
    "十九",
    "二十",
    "廿一",
    "廿二",
    "廿三",
    "廿四",
    "廿五",
    "廿六",
    "廿七",
    "廿八",
    "廿九",
    "三十",
  ];

  static const List<String> _hebrewMonthsEn = [
    "Nisan",
    "Iyar",
    "Sivan",
    "Tammuz",
    "Av",
    "Elul",
    "Tishrei",
    "Cheshvan",
    "Kislev",
    "Tevet",
    "Shevat",
    "Adar",
    "Adar II",
  ];

  static const List<String> _narrowWeekdaysEn = [
    "Su",
    "Mo",
    "Tu",
    "We",
    "Th",
    "Fr",
    "Sa",
  ];

  static const List<String> _narrowWeekdaysZh = [
    "日",
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
  ];

  static const List<String> _narrowWeekdaysTh = [
    "อา",
    "จ",
    "อ",
    "พ",
    "พฤ",
    "ศ",
    "ส",
  ];

  static const List<String> _narrowWeekdaysMy = [
    "နွေ",
    "လာ",
    "ဂါ",
    "ဟူး",
    "ကြာ",
    "သော",
    "နေ",
  ];

  static const List<String> _narrowWeekdaysPtBR = [
    "D",
    "S",
    "T",
    "Q",
    "Q",
    "S",
    "S",
  ];

  static const List<String> _narrowWeekdaysFrCA = [
    "D",
    "L",
    "M",
    "M",
    "J",
    "V",
    "S",
  ];

  static const List<String> _narrowWeekdaysIt = [
    "D",
    "L",
    "M",
    "M",
    "G",
    "V",
    "S",
  ];

  static const List<String> _narrowWeekdaysEs = [
    "D",
    "L",
    "M",
    "X",
    "J",
    "V",
    "S",
  ];

  /// Built-in English labels.
  static const BottomPickerLocalizations en = BottomPickerLocalizations(
    cancel: "Cancel",
    reset: "Reset",
    confirm: "Confirm",
    noData: "No data",
    loadingText: "Loading...",
    empty: "No data",
    noMoreData: "No More Data",
    all: "All",
    searchPlaceholder: "Search",
    selectedCount: "Selected {count}",
    calendarNames: _calendarNamesEn,
    lunarMonths: _lunarMonthsZh,
    lunarDays: _lunarDaysZh,
    hebrewMonths: _hebrewMonthsEn,
    narrowWeekdays: _narrowWeekdaysEn,
    firstDayOfWeekIndex: 0,
  );

  /// Built-in simplified Chinese labels.
  static const BottomPickerLocalizations zh = BottomPickerLocalizations(
    cancel: "取消",
    reset: "重置",
    confirm: "确认",
    noData: "暂无数据",
    loadingText: "加载中...",
    empty: "暂无数据",
    noMoreData: "没有更多数据",
    all: "全部",
    searchPlaceholder: "搜索",
    selectedCount: "已选 {count} 个",
    calendarNames: _calendarNamesZh,
    lunarMonths: _lunarMonthsZh,
    lunarDays: _lunarDaysZh,
    hebrewMonths: _hebrewMonthsEn,
    narrowWeekdays: _narrowWeekdaysZh,
    firstDayOfWeekIndex: 0,
  );

  /// Built-in traditional Chinese labels.
  static const BottomPickerLocalizations zhHant = BottomPickerLocalizations(
    cancel: "取消",
    reset: "重置",
    confirm: "確認",
    noData: "暫無資料",
    loadingText: "載入中...",
    empty: "暫無資料",
    noMoreData: "沒有更多資料",
    all: "全部",
    searchPlaceholder: "搜尋",
    selectedCount: "已選 {count} 個",
    calendarNames: _calendarNamesZhHant,
    lunarMonths: _lunarMonthsZhHant,
    lunarDays: _lunarDaysZh,
    hebrewMonths: _hebrewMonthsEn,
    narrowWeekdays: _narrowWeekdaysZh,
    firstDayOfWeekIndex: 0,
  );

  /// Built-in Thai labels.
  static const BottomPickerLocalizations th = BottomPickerLocalizations(
    cancel: "ยกเลิก",
    reset: "รีเซ็ต",
    confirm: "ยืนยัน",
    noData: "ไม่มีข้อมูล",
    loadingText: "กำลังโหลด...",
    empty: "ไม่มีข้อมูล",
    noMoreData: "ไม่พบข้อมูล",
    all: "ทั้งหมด",
    searchPlaceholder: "ค้นหา",
    selectedCount: "เลือกแล้ว {count}",
    calendarNames: _calendarNamesEn,
    lunarMonths: _lunarMonthsZh,
    lunarDays: _lunarDaysZh,
    hebrewMonths: _hebrewMonthsEn,
    narrowWeekdays: _narrowWeekdaysTh,
    firstDayOfWeekIndex: 0,
  );

  /// Built-in Burmese labels.
  static const BottomPickerLocalizations my = BottomPickerLocalizations(
    cancel: "ပယ်ဖျက်",
    reset: "Reset",
    confirm: "လုပ်မည်",
    noData: "No Data",
    loadingText: "Loading...",
    empty: "No Data",
    noMoreData: "နောက်ထပ်ဒေတာမရှိပါ",
    all: "အားလုံး",
    searchPlaceholder: "ရှာရန်",
    selectedCount: "Selected {count}",
    calendarNames: _calendarNamesEn,
    lunarMonths: _lunarMonthsZh,
    lunarDays: _lunarDaysZh,
    hebrewMonths: _hebrewMonthsEn,
    narrowWeekdays: _narrowWeekdaysMy,
    firstDayOfWeekIndex: 0,
  );

  /// Built-in Brazilian Portuguese labels.
  static const BottomPickerLocalizations ptBR = BottomPickerLocalizations(
    cancel: "Cancelar",
    confirm: "Confirmar",
    noData: "sem dados",
    loadingText: "Carregando...",
    empty: "sem dados",
    all: "Tudo",
    searchPlaceholder: "Busca",
    selectedCount: "Selecionado {count}",
    calendarNames: _calendarNamesEn,
    lunarMonths: _lunarMonthsZh,
    lunarDays: _lunarDaysZh,
    hebrewMonths: _hebrewMonthsEn,
    narrowWeekdays: _narrowWeekdaysPtBR,
    firstDayOfWeekIndex: 0,
  );

  /// Built-in Canadian French labels.
  static const BottomPickerLocalizations frCA = BottomPickerLocalizations(
    cancel: "Annuler",
    reset: "Réinit.",
    confirm: "Confirmer",
    noData: "Aucune Donnée",
    loadingText: "Chargement...",
    empty: "Aucune Donnée",
    noMoreData: "Plus de données",
    all: "Tout",
    searchPlaceholder: "Rechercher",
    selectedCount: "Sélectionné {count}",
    calendarNames: _calendarNamesEn,
    lunarMonths: _lunarMonthsZh,
    lunarDays: _lunarDaysZh,
    hebrewMonths: _hebrewMonthsEn,
    narrowWeekdays: _narrowWeekdaysFrCA,
    firstDayOfWeekIndex: 1,
  );

  /// Built-in Italian labels.
  static const BottomPickerLocalizations it = BottomPickerLocalizations(
    cancel: "Annullare",
    reset: "Reset",
    confirm: "Confermare",
    noData: "Nessun Dato",
    loadingText: "Caricamento...",
    empty: "Nessun Dato",
    noMoreData: "Nessun dato in più",
    all: "Tutto",
    searchPlaceholder: "Cercare",
    selectedCount: "Selezionato {count}",
    calendarNames: _calendarNamesEn,
    lunarMonths: _lunarMonthsZh,
    lunarDays: _lunarDaysZh,
    hebrewMonths: _hebrewMonthsEn,
    narrowWeekdays: _narrowWeekdaysIt,
    firstDayOfWeekIndex: 1,
  );

  /// Built-in Spanish labels.
  static const BottomPickerLocalizations es = BottomPickerLocalizations(
    cancel: "Cancelar",
    confirm: "Confirmar",
    noData: "No hay datos",
    loadingText: "Cargando...",
    empty: "No hay datos",
    all: "Toda",
    searchPlaceholder: "Buscar",
    selectedCount: "Seleccionado {count}",
    calendarNames: _calendarNamesEn,
    lunarMonths: _lunarMonthsZh,
    lunarDays: _lunarDaysZh,
    hebrewMonths: _hebrewMonthsEn,
    narrowWeekdays: _narrowWeekdaysEs,
    firstDayOfWeekIndex: 1,
  );

  /// Resolves built-in labels from a locale and falls back to English.
  static BottomPickerLocalizations byLocale(Locale? locale) {
    final languageCode = locale?.languageCode.toLowerCase();
    final countryCode = locale?.countryCode?.toUpperCase();
    if (languageCode == "zh") {
      if (locale?.scriptCode == "Hant" ||
          countryCode == "TW" ||
          countryCode == "HK" ||
          countryCode == "MO") {
        return zhHant;
      }
      return zh;
    }
    if (languageCode == "th") {
      return th;
    }
    if (languageCode == "my") {
      return my;
    }
    if (languageCode == "pt") {
      return ptBR;
    }
    if (languageCode == "fr") {
      return frCA;
    }
    if (languageCode == "it") {
      return it;
    }
    if (languageCode == "es") {
      return es;
    }
    return en;
  }

  static bool isSupported(Locale? locale) {
    final languageCode = locale?.languageCode.toLowerCase();
    return languageCode == "zh" ||
        languageCode == "en" ||
        languageCode == "th" ||
        languageCode == "my" ||
        languageCode == "pt" ||
        languageCode == "fr" ||
        languageCode == "it" ||
        languageCode == "es";
  }
}
