part of flutter_bottom_sheet_pickers.src;

/// Built-in text labels resolved from locale.
class BuiltInLocalizations {
  BuiltInLocalizations._();

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
