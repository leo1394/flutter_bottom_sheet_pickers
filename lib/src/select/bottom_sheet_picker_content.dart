// ignore_for_file: must_be_immutable
part of flutter_bottom_sheet_pickers.src;

const int _defaultPageSize = 50;

class BottomSheetPickerContent<T> extends StatefulWidget {
  String? title;
  String? placeholder;
  bool? isSearchSupported = true;
  SelectionMode mode = SelectionMode.SINGLE;
  Map<String, dynamic>? parameters = {};
  LazyRequestFuture<T>? lazyRequestFuture;
  ItemBuilder<T>? itemBuilder;
  bool? isFullRowItem;
  bool isAllowNoSelection = false;
  Alignment? alignment;
  List<T> announcedData = <T>[];
  List<T> disabledValues = <T>[];
  dynamic initialValue;
  BottomPickerTheme themeData;
  BottomPickerLocalizations? texts;
  BottomPickerLocalizationBuilder? textsBuilder;
  bool confirmOnTap;
  double? height;

  BottomSheetPickerContent({
    this.title,
    this.placeholder,
    this.isSearchSupported = true,
    this.mode = SelectionMode.SINGLE,
    this.parameters,
    this.lazyRequestFuture,
    this.itemBuilder,
    this.disabledValues = const [],
    this.isFullRowItem = false,
    this.isAllowNoSelection = false,
    this.alignment = Alignment.centerLeft,
    required this.announcedData,
    this.initialValue,
    this.themeData = BottomPickerTheme.defaults,
    this.texts,
    this.textsBuilder,
    this.confirmOnTap = false,
    this.height,
  });

  @override
  State<BottomSheetPickerContent<T>> createState() =>
      _BottomSheetPickerContentState<T>();
}

class _BottomSheetPickerContentState<T>
    extends State<BottomSheetPickerContent<T>> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  late final ValueNotifier<List<T>> _dataNotifier;
  Object? Function()? onConfirm;
  Widget Function(BuildContext context, StateSetter setModalState)? _builder;
  String? _keyword;
  int _pageIndex = 0;
  bool _isLoading = false;
  bool _isAllDataLoaded = false;
  bool get _isConfirmEnabled {
    return widget.isAllowNoSelection ||
        (widget.mode == SelectionMode.SINGLE
            ? widget.initialValue != null
            : (widget.initialValue as Set<T>).isNotEmpty);
  }

  List<T> _data = <T>[];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _keyword ?? '');
    _scrollController = ScrollController();
    _dataNotifier = ValueNotifier(<T>[]);

    // 重置状态，支持实例复用
    _pageIndex = 0;
    _isLoading = false;
    _isAllDataLoaded = false;
    _data = [];
    if (widget.lazyRequestFuture == null) {
      _applyLocalFilter();
    } else {
      _scrollController.addListener(onScroll);
    }

    _builder = (context, setModalState) {
      final texts = BottomPickerLocalizations.resolve(context,
          texts: widget.texts, textsBuilder: widget.textsBuilder);
      if (_data.isEmpty && _isAllDataLoaded == true) {
        return _SelectorEmptyWidget(texts: texts);
      }
      if (widget.lazyRequestFuture != null &&
          _pageIndex == 0 &&
          _isAllDataLoaded == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            onLoadUpMore();
          }
        });
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: widget.themeData.checkedColor,
            ),
          ),
        );
      }
      return ValueListenableBuilder<List<T>>(
        valueListenable: _dataNotifier,
        builder: (_, data, __) => ListView.separated(
          itemCount: (data.length + (widget.lazyRequestFuture == null ? 0 : 1)),
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Colors.transparent),
          controller: _scrollController,
          itemBuilder: (_, index) {
            if (index >= data.length)
              return _SelectorListFooter(_isLoading)
                  .show(context, widget.themeData, texts);
            final element = data[index];
            final checked = widget.mode == SelectionMode.SINGLE
                ? element == widget.initialValue
                : (widget.initialValue as Set<T>).contains(element);
            final disabled = widget.disabledValues.contains(element);
            return InkWell(
              onTap: () {
                if (disabled) {
                  return;
                }
                setModalState(() {
                  if (widget.mode == SelectionMode.SINGLE) {
                    widget.initialValue = checked ? null : element;
                  } else {
                    if (checked) {
                      (widget.initialValue as Set<T>).remove(element);
                    } else {
                      (widget.initialValue as Set<T>).add(element);
                    }
                  }
                });
                if (widget.confirmOnTap &&
                    widget.mode == SelectionMode.SINGLE) {
                  Navigator.of(context).pop(element);
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: index == 0 ? 5 : 0),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                color: disabled
                    ? const Color(0x0A000000)
                    : checked
                        ? widget.themeData.selectedOptionBackgroundColor
                        : Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                        child: widget.itemBuilder != null
                            ? widget.itemBuilder!(
                                context, setModalState, element, checked)
                            : Align(
                                alignment:
                                    widget.alignment ?? Alignment.centerLeft,
                                child: Text(
                                  element.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF262626),
                                  ),
                                ),
                              )),
                    if (widget.isFullRowItem != true)
                      Icon(
                        checked ? Icons.check : null,
                        size: 18,
                        color: checked
                            ? widget.themeData.checkedColor
                            : const Color(0xFFCDD3DF),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    };
    onConfirm = () => widget.mode == SelectionMode.SINGLE
        ? (widget.initialValue as T?)
        : (widget.initialValue as Set<T>).toList();
  }

  @override
  void dispose() {
    _scrollController.removeListener(onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _dataNotifier.dispose();
    super.dispose();
  }

  void onResetAndSearch() {
    _keyword = _searchController.text.trim();
    _pageIndex = 0;
    _isLoading = false;
    _isAllDataLoaded = false;
    _data = [];
    _dataNotifier.value = [];
    if (widget.lazyRequestFuture == null) {
      _applyLocalFilter();
      setState(() {});
      return;
    }
    setState(() {});
  }

  void onScroll() {
    if (widget.lazyRequestFuture == null ||
        _isAllDataLoaded ||
        _isLoading ||
        !_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      onLoadUpMore();
    }
  }

  void _applyLocalFilter() {
    final String searchKeyword = (_keyword ?? '').trim().toLowerCase();
    _data = searchKeyword.isEmpty
        ? List<T>.from(widget.announcedData)
        : widget.announcedData
            .where((option) =>
                option.toString().toLowerCase().contains(searchKeyword))
            .toList();
    _isLoading = false;
    _isAllDataLoaded = true;
    _dataNotifier.value = List<T>.from(_data);
  }

  Future<void> onLoadUpMore() async {
    if (!mounted || _isLoading || _isAllDataLoaded) return;
    if (widget.lazyRequestFuture == null) {
      _applyLocalFilter();
      setState(() {});
      return;
    }
    if (_pageIndex == 0) {
      // 搜索时重置分页和数据状态，支持搜索结果的分页加载
      _isAllDataLoaded = false;
      _data = [];
      _dataNotifier.value = [];
    }
    _pageIndex++;
    _isLoading = true;
    final Map<String, dynamic> paramObj = {
      ...?widget.parameters,
      "page_index": _pageIndex,
      "page_size": _defaultPageSize,
      "keyword": _keyword
    };
    final List<T> results =
        await widget.lazyRequestFuture?.call(paramObj) ?? <T>[];
    if (!mounted) {
      return;
    }
    _data.addAll(results);
    _isLoading = false;
    if (results.isEmpty ||
        results.length < (paramObj["page_size"] ?? _defaultPageSize)) {
      _isAllDataLoaded = true;
    }
    _dataNotifier.value = List<T>.from(_data);
    setState(() {});
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
                maxHeight: widget.height != null
                    ? widget.height! + mediaQuery.padding.bottom
                    : mediaQuery.size.height * 0.68 + mediaQuery.padding.bottom,
                minHeight: widget.height != null
                    ? widget.height! + mediaQuery.padding.bottom
                    : mediaQuery.size.height * 0.55 + mediaQuery.padding.bottom,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
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
                        if (widget.isSearchSupported == true)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: TextField(
                              controller: _searchController,
                              textInputAction: TextInputAction.search,
                              onChanged: (value) =>
                                  setState(() => _keyword = value),
                              onSubmitted: (_) => onResetAndSearch(),
                              decoration: InputDecoration(
                                constraints: BoxConstraints(maxHeight: 40),
                                hintText: widget.placeholder ??
                                    texts.searchPlaceholder,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF9FAABB),
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF9FAABB),
                                  size: 20,
                                ),
                                suffixIcon: (_keyword ?? '').trim().isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Color(0xFF9FAABB),
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _keyword = '';
                                            _searchController.clear();
                                          });
                                          onResetAndSearch();
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: const Color(0x0D000000),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        if (_builder != null)
                          Flexible(
                            child: _builder!(context, setState),
                          ),
                      ],
                    ),
                  ),
                  if (!widget.confirmOnTap)
                    Container(
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
                                    borderRadius:
                                        widget.themeData.buttonBorderRadius,
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
                                    : () =>
                                        Navigator.of(context).pop(onConfirm!()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      widget.themeData.buttonBackgroundColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        widget.themeData.buttonBorderRadius,
                                  ),
                                  disabledBackgroundColor: widget
                                      .themeData.disabledButtonBackgroundColor,
                                  disabledForegroundColor: Colors.white,
                                  disabledMouseCursor:
                                      SystemMouseCursors.forbidden,
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
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
