part of flutter_bottom_sheet_pickers.src;

class _BottomSheetPicker<T> {
  BuildContext mContext;
  String? title;
  String? placeholder;
  bool? isSearchSupported = false;
  SelectionMode mode = SelectionMode.SINGLE;
  Alignment? alignment = Alignment.centerLeft;
  BottomPickerTheme themeData;
  ItemBuilder<T>? itemBuilder;
  bool isFullRowItem = false;
  bool isAllowNoSelection = false;
  bool isConfirmOnTap = false;
  double? sheetHeight;
  LazyRequestFuture<T>? _lazyRequestFuture;
  Map<String, dynamic>? _parameters = {};
  List<T> _announcedData = <T>[];
  List<dynamic> _disabledValues = <dynamic>[];
  dynamic _tempSelected;
  dynamic _cascadeOptions;
  dynamic _cascadeInitialValue;
  bool _isCascadeMode = false;
  bool _cascadeAddAllItem = false;
  String? _cascadeAllItemLabel;

  _BottomSheetPicker(
    this.mContext, {
    this.title,
    this.itemBuilder,
    this.mode = SelectionMode.SINGLE,
    this.isFullRowItem = false,
    this.isSearchSupported = false,
    this.alignment = Alignment.centerLeft,
    this.themeData = BottomPickerTheme.defaults,
  });

  /// 初始化选择器的填充
  _BottomSheetPicker init(
      {List<T>? options, dynamic initialValue, List<T>? disabledValues}) {
    assert(
        this.mode == SelectionMode.SINGLE && (initialValue is T?) ||
            this.mode == SelectionMode.MULTIPLE && (initialValue is List<T>?),
        "Only ${this.mode == SelectionMode.SINGLE ? T.toString() : 'List<${T.toString()}>'}? supported for ${this.mode} selection mode.");
    _announcedData = options ?? <T>[];
    _disabledValues = disabledValues ?? <T>[];
    _tempSelected = this.mode == SelectionMode.SINGLE
        ? initialValue as T?
        : {...((initialValue ?? const []) as List<T>)};
    return this;
  }

  /// 初始化单选选择器
  _BottomSheetPicker single(
      {List<T>? options, T? initialValue, List<T>? disabledValues}) {
    this.mode = SelectionMode.SINGLE;
    _announcedData = options ?? <T>[];
    if (initialValue != null) {
      _tempSelected = initialValue;
    }
    if (disabledValues != null) {
      _disabledValues = disabledValues;
    }
    return this;
  }

  /// 初始化多选选择器
  _BottomSheetPicker multiple(
      {List<T>? options, List<T>? initialValue, List<T>? disabledValues}) {
    this.mode = SelectionMode.MULTIPLE;
    _announcedData = options ?? <T>[];
    if (initialValue != null) {
      _tempSelected = {...initialValue};
    }
    if (disabledValues != null) {
      _disabledValues = disabledValues;
    }
    return this;
  }

  /// 初始化级联选择器，最多支持三级
  _BottomSheetPicker cascade(
      {required dynamic options,
      dynamic initialValue,
      bool addAllItem = false,
      String? allItemLabel}) {
    _isCascadeMode = true;
    _cascadeOptions = options;
    _cascadeInitialValue = initialValue;
    if (initialValue != null) {
      _tempSelected = initialValue;
    }
    _cascadeAddAllItem = addAllItem;
    _cascadeAllItemLabel = allItemLabel;
    return this;
  }

  /// 初始化级联选择器支持非一级节点全选
  _BottomSheetPicker cascadeAllItemSupported({String? allItemLabel}) {
    _cascadeAddAllItem = true;
    if (allItemLabel != null) {
      _cascadeAllItemLabel = allItemLabel;
    }
    return this;
  }

  /// 初始化空选时允许确认
  _BottomSheetPicker allowNoSelection() {
    this.isAllowNoSelection = true;
    return this;
  }

  /// 初始化单选项点击后直接确认
  _BottomSheetPicker confirmOnTap() {
    this.isConfirmOnTap = true;
    return this;
  }

  /// 初始化 bottom sheet 弹窗高度
  _BottomSheetPicker height(double value) {
    this.sheetHeight = value;
    return this;
  }

  /// 初始化分页懒加载选择器
  _BottomSheetPicker lazyLoad(
      {required LazyRequestFuture<T>? lazyRequestFuture,
      Map<String, dynamic>? parameters,
      dynamic initialValue,
      List<T>? disabledValues}) {
    this._lazyRequestFuture = lazyRequestFuture;
    this._parameters = parameters;
    _announcedData = <T>[];
    if (initialValue != null) {
      _tempSelected = this.mode == SelectionMode.SINGLE
          ? initialValue as T?
          : {...((initialValue ?? const []) as List<T>)};
    }
    if (disabledValues != null) {
      _disabledValues = disabledValues;
    }
    return this;
  }

  /// 初始化支持搜索/过滤选择器
  _BottomSheetPicker searchSupported({String? placeholder}) {
    this.isSearchSupported = true;
    if (placeholder != null) {
      this.placeholder = placeholder;
    }
    return this;
  }

  /// 初始化支持整行选择器
  _BottomSheetPicker fullRow({ItemBuilder<T>? itemBuilder}) {
    this.isFullRowItem = true;
    if (itemBuilder != null) {
      this.itemBuilder = itemBuilder;
    }
    return this;
  }

  /// 初始化显示对齐方式，默认为居左
  _BottomSheetPicker align(Alignment alignment, {ItemBuilder<T>? itemBuilder}) {
    this.alignment = alignment;
    if (itemBuilder != null) {
      this.itemBuilder = itemBuilder;
    }
    return this;
  }

  Future<dynamic> show() {
    final textConfig = BottomPickerConfig.maybeOf(mContext);
    return showModalBottomSheet<dynamic>(
      context: mContext,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        Widget sheet;
        if (_isCascadeMode) {
          sheet = CascadePickerContent(
            title: title,
            options: _cascadeOptions,
            initialValue: _tempSelected ?? _cascadeInitialValue,
            mode: mode,
            itemBuilder: itemBuilder as ItemBuilder<CascadeOption>?,
            isFullRowItem: isFullRowItem,
            isAllowNoSelection: isAllowNoSelection,
            alignment: alignment,
            disabledValues: _disabledValues,
            addAllItem: _cascadeAddAllItem,
            allItemLabel: _cascadeAllItemLabel,
            themeData: themeData,
            texts: textConfig?.localizations,
            textsBuilder: textConfig?.localizationBuilder,
            height: sheetHeight,
          );
        } else {
          sheet = BottomSheetPickerContent<T>(
            title: title,
            placeholder: placeholder,
            isSearchSupported: isSearchSupported,
            mode: mode,
            parameters: _parameters,
            lazyRequestFuture: _lazyRequestFuture,
            itemBuilder: itemBuilder,
            isFullRowItem: isFullRowItem,
            isAllowNoSelection: isAllowNoSelection,
            alignment: alignment,
            announcedData: _announcedData,
            disabledValues: _disabledValues.cast<T>(),
            initialValue: _tempSelected,
            themeData: themeData,
            texts: textConfig?.localizations,
            textsBuilder: textConfig?.localizationBuilder,
            confirmOnTap: isConfirmOnTap,
            height: sheetHeight,
          );
        }
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
                child: sheet,
              ),
            ],
          ),
        );
      },
    );
  }
}
