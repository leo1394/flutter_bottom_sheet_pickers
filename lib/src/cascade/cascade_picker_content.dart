part of flutter_bottom_sheet_pickers.src;

class CascadePickerContent extends StatefulWidget {
  final String? title;
  final dynamic options;
  final dynamic initialValue;
  final SelectionMode mode;
  final ItemBuilder<CascadeOption>? itemBuilder;
  final bool isFullRowItem;
  final bool isAllowNoSelection;
  final Alignment? alignment;
  final List<dynamic> disabledValues;
  final bool addAllItem;
  final String? allItemLabel;
  final BottomPickerTheme themeData;
  final BottomPickerLocalizations? texts;
  final BottomPickerLocalizationBuilder? textsBuilder;
  final double? height;

  const CascadePickerContent({
    this.title,
    required this.options,
    this.initialValue,
    this.mode = SelectionMode.SINGLE,
    this.itemBuilder,
    this.isFullRowItem = false,
    this.isAllowNoSelection = false,
    this.alignment = Alignment.centerLeft,
    this.disabledValues = const [],
    this.addAllItem = false,
    this.allItemLabel,
    this.themeData = BottomPickerTheme.defaults,
    this.texts,
    this.textsBuilder,
    this.height,
  });

  @override
  State<CascadePickerContent> createState() => _CascadePickerContentState();
}

class _CascadePickerContentState extends State<CascadePickerContent> {
  late final List<CascadeOption> _options;
  late final int _maxDepth;
  final Set<String> _selectedKeys = <String>{};
  final Map<String, CascadeSelection> _selectedValues =
      <String, CascadeSelection>{};
  CascadeOption? _level1;
  CascadeOption? _level2;
  CascadeOption? _level3;
  CascadeOption? _expandedLevel1;
  CascadeOption? _expandedLevel2;
  late FixedExtentScrollController _level1Controller;
  late FixedExtentScrollController _level2Controller;
  late FixedExtentScrollController _level3Controller;

  @override
  void initState() {
    super.initState();
    _options = _parseCascadeOptions(widget.options);
    _maxDepth = _cascadeDepth(_options);
    if (_maxDepth > 3) {
      throw ArgumentError("Cascade selector supports up to 3 levels.");
    }
    _applyInitialValue();
    _level1Controller = FixedExtentScrollController(
        initialItem: _initialIndex(_options, _expandedLevel1 ?? _level1));
    _level2Controller = FixedExtentScrollController(
        initialItem: _initialIndex(
            _childrenOf(_expandedLevel1), _expandedLevel2 ?? _level2));
    _level3Controller = FixedExtentScrollController(
        initialItem: _initialIndex(_childrenOf(_expandedLevel2), _level3));
  }

  @override
  void dispose() {
    _level1Controller.dispose();
    _level2Controller.dispose();
    _level3Controller.dispose();
    super.dispose();
  }

  List<CascadeOption> _parseCascadeOptions(dynamic options) {
    if (options is List<CascadeOption>) {
      return options;
    }
    if (options is List) {
      return options
          .map(
              (item) => _parseMapOption(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
    if (options is Map) {
      return _parseAdjacencyOptions(options);
    }
    throw ArgumentError("Unsupported cascade options type.");
  }

  CascadeOption _parseMapOption(Map<String, dynamic> item) {
    final rawChildren = item["children"];
    return CascadeOption(
      id: "${item["id"]}",
      label: _resolveOptionLabel(item),
      value: item["value"],
      children: rawChildren is List
          ? rawChildren
              .map((child) =>
                  _parseMapOption(Map<String, dynamic>.from(child as Map)))
              .toList()
          : const [],
    );
  }

  String _resolveOptionLabel(Map<String, dynamic> item) {
    for (final key in ["label", "value", "name", "id"]) {
      final value = item[key];
      if (value != null && "$value".trim().isNotEmpty) {
        return "$value";
      }
    }
    return "";
  }

  List<CascadeOption> _parseAdjacencyOptions(Map options) {
    final Map<String, Map<String, String>> tree =
        Map<String, Map<String, String>>.from(options.map((key, value) =>
            MapEntry("$key", Map<String, String>.from(value as Map))));
    final Set<String> childIds = <String>{};
    tree.values.forEach((children) => childIds.addAll(children.keys));
    final List<String> rootIds =
        tree.keys.where((id) => !childIds.contains(id)).toList();
    if (rootIds.isEmpty) {
      throw ArgumentError("Invalid cascade options: root node not found.");
    }
    return rootIds
        .map((id) => _buildAdjacencyOption(id, id, tree, <String>{}))
        .toList();
  }

  CascadeOption _buildAdjacencyOption(String id, String label,
      Map<String, Map<String, String>> tree, Set<String> visiting) {
    if (visiting.contains(id)) {
      throw ArgumentError(
          "Invalid cascade options: circular reference detected.");
    }
    visiting.add(id);
    final children = tree[id]
            ?.entries
            .map((entry) => _buildAdjacencyOption(
                entry.key, entry.value, tree, Set<String>.from(visiting)))
            .toList() ??
        <CascadeOption>[];
    return CascadeOption(id: id, label: label, children: children);
  }

  int _cascadeDepth(List<CascadeOption> options) {
    if (options.isEmpty) {
      return 0;
    }
    return options
        .map((item) => 1 + _cascadeDepth(item.children))
        .reduce((a, b) => a > b ? a : b);
  }

  List<CascadeOption> _childrenOf(CascadeOption? option,
      {bool allowAll = true, BottomPickerLocalizations? texts}) {
    if (option == null) {
      return <CascadeOption>[];
    }
    if (_isAllOption(option)) {
      return <CascadeOption>[];
    }
    if (widget.addAllItem && allowAll) {
      if (_isSingleLevelMultipleAllProxy(option)) {
        return [_allOption(texts: texts)];
      }
      return [_allOption(texts: texts), ...option.children];
    }
    if (option.children.isEmpty) {
      return <CascadeOption>[];
    }
    return option.children;
  }

  void _applyInitialValue() {
    if (widget.mode == SelectionMode.MULTIPLE) {
      _applyMultipleInitialValue();
      _expandedLevel1 =
          _level1 ?? (_options.isNotEmpty ? _options.first : null);
      return;
    }
    final initial = widget.initialValue;
    final level1Id = initial?.level1?.id;
    final level2Id = initial?.level2?.id;
    final level3Id = initial?.level3?.id;
    if (level1Id == null && level2Id == null && level3Id == null) {
      _clearSelection();
      _expandedLevel1 = _options.isNotEmpty ? _options.first : null;
      return;
    }
    if (level1Id == null || level2Id == null && level3Id != null) {
      _clearSelection();
      return;
    }
    _level1 = _findById(_options, level1Id);
    if (_level1 == null) {
      _clearSelection();
      return;
    }
    _expandedLevel1 = _level1;
    final level2Options = _childrenOf(_level1);
    if (level2Id == null) {
      _level2 = null;
      _level3 = null;
      _expandedLevel2 = null;
      return;
    }
    _level2 = _findById(level2Options, level2Id);
    if (_level2 == null) {
      _clearSelection();
      return;
    }
    _expandedLevel2 = _level2;
    final level3Options = _childrenOf(_level2);
    if (level3Id == null) {
      _level3 = null;
      return;
    }
    _level3 = _findById(level3Options, level3Id);
    if (_level3 == null) {
      _clearSelection();
    }
  }

  void _applyMultipleInitialValue() {
    _selectedKeys.clear();
    _selectedValues.clear();
    final initial = widget.initialValue;
    if (initial == null) {
      return;
    }
    final Iterable values = initial is Iterable ? initial : [initial];
    for (final item in values) {
      CascadeSelection? selection;
      if (item is CascadeSelection) {
        selection = item;
      } else if (item is CascadeOption) {
        selection = _selectionForPath([item]);
      }
      if (selection == null || selection.path.isEmpty) {
        continue;
      }
      final path = _resolvePath(selection);
      if (path.isEmpty) {
        continue;
      }
      if (path.length == 1 && _isSingleLevelMultipleAllProxy(path[0])) {
        path.add(_allOption());
      }
      _setSubtreeSelected(path, true);
      _level1 ??= path.isNotEmpty ? path[0] : null;
      _level2 ??= path.length > 1 ? path[1] : null;
      _level3 ??= path.length > 2 ? path[2] : null;
      _expandedLevel1 ??= _level1;
      _expandedLevel2 ??= _level2;
    }
    _syncAggregateSelections();
  }

  void _clearSelection() {
    _level1 = null;
    _level2 = null;
    _level3 = null;
    _expandedLevel1 = null;
    _expandedLevel2 = null;
  }

  CascadeOption? _findById(List<CascadeOption> options, String? id) {
    if (id == null || id.isEmpty) {
      return null;
    }
    for (final option in options) {
      if (option.id == id) {
        return option;
      }
    }
    return null;
  }

  int _initialIndex(List<CascadeOption> options, CascadeOption? selected) {
    if (selected == null) {
      return 0;
    }
    int index = options.indexWhere((option) => option.id == selected.id);
    return index < 0 ? 0 : index;
  }

  void _jumpToFirstItem(FixedExtentScrollController controller) {
    if (controller.hasClients) {
      controller.jumpToItem(0);
    }
  }

  CascadeOption? _defaultAllChild(CascadeOption option) {
    if (!widget.addAllItem || _isAllOption(option)) {
      return null;
    }
    final children = _childrenOf(option);
    if (children.isNotEmpty && _isAllOption(children.first)) {
      return children.first;
    }
    return null;
  }

  void _selectLevel1(CascadeOption option) {
    setState(() {
      _level1 = option;
      _level2 = _defaultAllChild(option);
      _level3 = null;
      _expandedLevel1 = option;
      _expandedLevel2 = null;
      _jumpToFirstItem(_level2Controller);
      _jumpToFirstItem(_level3Controller);
    });
  }

  void _selectLevel2(CascadeOption option) {
    setState(() {
      _level1 = _level1 ?? _expandedLevel1;
      _level2 = option;
      _level3 = _defaultAllChild(option);
      _expandedLevel2 = option;
      _jumpToFirstItem(_level3Controller);
    });
  }

  void _selectLevel3(CascadeOption option) {
    setState(() {
      _level1 = _level1 ?? _expandedLevel1;
      _level2 = _level2 ?? _expandedLevel2;
      _level3 = option;
    });
  }

  CascadeSelection _selection() {
    return CascadeSelection(level1: _level1, level2: _level2, level3: _level3);
  }

  List<CascadeOption> _resolvePath(CascadeSelection selection) {
    final List<CascadeOption> path = <CascadeOption>[];
    List<CascadeOption> options = _options;
    for (final selected in selection.path) {
      if (selected.id == "-1" && widget.addAllItem) {
        path.add(_allOption());
        options = <CascadeOption>[];
        continue;
      }
      final option = _findById(options, selected.id);
      if (option == null) {
        return <CascadeOption>[];
      }
      path.add(option);
      options = option.children;
    }
    return path;
  }

  CascadeSelection _selectionForPath(List<CascadeOption> path) {
    return CascadeSelection(
      level1: path.isNotEmpty ? path[0] : null,
      level2: path.length > 1 ? path[1] : null,
      level3: path.length > 2 ? path[2] : null,
    );
  }

  String _pathKey(List<CascadeOption> path) =>
      path.map((option) => option.id).join("\u0001");

  CascadeOption _allOption({BottomPickerLocalizations? texts}) {
    return CascadeOption(
        id: "-1",
        label: widget.allItemLabel ??
            texts?.all ??
            BottomPickerLocalizations.en.all);
  }

  bool _isAllOption(CascadeOption option) =>
      widget.addAllItem && option.id == "-1";

  bool _isSingleLevelMultipleAllProxy(CascadeOption option) {
    return widget.addAllItem &&
        widget.mode == SelectionMode.MULTIPLE &&
        _maxDepth == 1 &&
        option.children.isEmpty;
  }

  bool _isSingleLevelMultipleAllProxyItem(_CascadeFlatItem item) {
    return item.depth == 0 && _isSingleLevelMultipleAllProxy(item.option);
  }

  bool _hasSelectedAllChild(List<CascadeOption> path) {
    if (path.isEmpty || _isAllOption(path.last)) {
      return false;
    }
    if (path.length == 1) {
      return _level1?.id == path[0].id &&
          _level2 != null &&
          _isAllOption(_level2!);
    }
    if (path.length == 2) {
      return _level1?.id == path[0].id &&
          _level2?.id == path[1].id &&
          _level3 != null &&
          _isAllOption(_level3!);
    }
    return false;
  }

  bool _isSelectable(_CascadeFlatItem item) {
    if (_isDisabledPath(item.path)) {
      return false;
    }
    if (item.depth == 0) {
      return false;
    }
    return true;
  }

  bool _isDisabledPath(List<CascadeOption> path) {
    final key = _pathKey(path);
    final option = path.last;
    for (final disabled in widget.disabledValues) {
      if (disabled is CascadeSelection) {
        final disabledPath = _resolvePath(disabled);
        if (disabledPath.isNotEmpty && _pathKey(disabledPath) == key) {
          return true;
        }
      } else if (disabled is CascadeOption) {
        if (disabled.id == option.id) {
          return true;
        }
      } else if ("$disabled" == option.id || "$disabled" == key) {
        return true;
      }
    }
    return false;
  }

  bool _isChecked(_CascadeFlatItem item) {
    if (_isSingleLevelMultipleAllProxyItem(item)) {
      return false;
    }
    return _isPathChecked(item.path);
  }

  bool _isPathChecked(List<CascadeOption> path) {
    if (path.isEmpty) {
      return false;
    }
    if (_isAllOption(path.last)) {
      return _isAllPathChecked(path);
    }
    if (path.length == 1) {
      return false;
    }
    final children = path.last.children;
    if (children.isEmpty) {
      return _selectedKeys.contains(_pathKey(path));
    }
    return children.every((child) => _isPathChecked([...path, child]));
  }

  bool _hasCheckedDescendant(List<CascadeOption> path) {
    if (path.isEmpty || _isAllOption(path.last)) {
      return false;
    }
    if (_isSingleLevelMultipleAllProxy(path.last)) {
      return _selectedKeys.contains(_pathKey([...path, _allOption()]));
    }
    for (final child in path.last.children) {
      final childPath = [...path, child];
      if (_isPathChecked(childPath) || _hasCheckedDescendant(childPath)) {
        return true;
      }
    }
    return false;
  }

  bool _isAllPathChecked(List<CascadeOption> path) {
    if (path.length < 2) {
      return false;
    }
    final parentPath = path.sublist(0, path.length - 1);
    final parent = parentPath.last;
    if (parent.children.isEmpty) {
      return _selectedKeys.contains(_pathKey(path));
    }
    return parent.children
        .every((child) => _isPathChecked([...parentPath, child]));
  }

  bool _isExpandedMultiple(_CascadeFlatItem item) {
    if (item.depth == 0) {
      return item.option.id == _expandedLevel1?.id;
    }
    if (item.depth == 1) {
      return item.option.id == _expandedLevel2?.id;
    }
    return false;
  }

  bool _hasMultipleChildren(_CascadeFlatItem item) {
    return _childrenOf(item.option).isNotEmpty;
  }

  void _expandMultiple(_CascadeFlatItem item) {
    if (!_hasMultipleChildren(item)) {
      return;
    }
    setState(() {
      if (item.depth == 0) {
        _expandedLevel1 = item.option;
        _expandedLevel2 = null;
        return;
      }
      if (item.depth == 1) {
        _expandedLevel2 = item.option;
      }
    });
  }

  void _toggleMultiple(_CascadeFlatItem item) {
    if (!_isSelectable(item)) {
      return;
    }
    final checked = _isChecked(item);
    setState(() {
      if (_isAllOption(item.option)) {
        _setAllPathSelected(item.path, !checked);
      } else {
        _setSubtreeSelected(item.path, !checked);
      }
      _syncAggregateSelections();
    });
  }

  void _setAllPathSelected(List<CascadeOption> path, bool selected) {
    if (path.length < 2) {
      return;
    }
    final parentPath = path.sublist(0, path.length - 1);
    final parent = parentPath.last;
    _setSelectionPath(path, selected);
    if (parent.children.isEmpty) {
      return;
    }
    for (final child in parent.children) {
      _setSubtreeSelected([...parentPath, child], selected);
    }
  }

  void _setSubtreeSelected(List<CascadeOption> path, bool selected) {
    if (path.isEmpty || _isAllOption(path.last)) {
      _setAllPathSelected(path, selected);
      return;
    }
    _setSelectionPath(path, selected);
    for (final child in path.last.children) {
      _setSubtreeSelected([...path, child], selected);
    }
  }

  void _setSelectionPath(List<CascadeOption> path, bool selected) {
    if (path.isEmpty) {
      return;
    }
    final key = _pathKey(path);
    if (path.length == 1 && !_isAllOption(path.last) && selected) {
      return;
    }
    if (selected) {
      _selectedKeys.add(key);
      _selectedValues[key] = _selectionForPath(path);
      return;
    }
    _selectedKeys.remove(key);
    _selectedValues.remove(key);
  }

  void _syncAggregateSelections() {
    for (final option in _options) {
      _syncAggregateForPath([option]);
      _setSelectionPath([option], false);
    }
  }

  bool _syncAggregateForPath(List<CascadeOption> path) {
    final option = path.last;
    if (option.children.isEmpty) {
      if (_isSingleLevelMultipleAllProxy(option)) {
        return _selectedKeys.contains(_pathKey([...path, _allOption()]));
      }
      return _selectedKeys.contains(_pathKey(path));
    }
    final bool allChildrenChecked = option.children
        .every((child) => _syncAggregateForPath([...path, child]));
    if (path.length > 1) {
      _setSelectionPath(path, allChildrenChecked);
    }
    if (widget.addAllItem) {
      _setSelectionPath([...path, _allOption()], allChildrenChecked);
    }
    return allChildrenChecked;
  }

  void _tapMultipleItem(_CascadeFlatItem item) {
    if (_isSingleLevelMultipleAllProxyItem(item)) {
      _expandMultiple(item);
      return;
    }
    if (_hasMultipleChildren(item)) {
      _expandMultiple(item);
      if (!_isSelectable(item)) {
        return;
      }
    }
    _toggleMultiple(item);
  }

  bool get _isConfirmEnabled {
    if (widget.isAllowNoSelection) {
      return true;
    }
    if (widget.mode == SelectionMode.MULTIPLE) {
      return _selectedKeys.isNotEmpty;
    }
    return _level1 != null;
  }

  Widget _buildSingleColumn(
      List<CascadeOption> options,
      CascadeOption? selected,
      ValueChanged<CascadeOption> onSelected,
      FixedExtentScrollController controller,
      {List<CascadeOption> parents = const []}) {
    return Expanded(
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          if (!controller.hasClients || options.isEmpty) {
            return false;
          }
          final index = controller.selectedItem.clamp(0, options.length - 1);
          final option = options[index];
          if (_isDisabledPath([...parents, option])) {
            return false;
          }
          onSelected(option);
          return false;
        },
        child: CupertinoPicker.builder(
          scrollController: controller,
          itemExtent: 44,
          selectionOverlay: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFEFF0F6)),
                bottom: BorderSide(color: Color(0xFFEFF0F6)),
              ),
            ),
          ),
          onSelectedItemChanged: (_) {},
          childCount: options.length,
          itemBuilder: (_, index) {
            final option = options[index];
            final path = [...parents, option];
            final checked = option.id == selected?.id;
            final showCheckedIcon = checked &&
                (_isAllOption(option) || option.children.isEmpty) &&
                !_hasSelectedAllChild(path);
            final disabled = _isDisabledPath(path);
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (disabled) {
                  return;
                }
                if (controller.hasClients && controller.selectedItem == index) {
                  onSelected(option);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                color: disabled
                    ? const Color(0x0A000000)
                    : checked
                        ? widget.themeData.selectedOptionBackgroundColor
                        : Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: widget.alignment ?? Alignment.centerLeft,
                        child: widget.itemBuilder != null
                            ? widget.itemBuilder!(
                                context, setState, option, checked)
                            : Text(
                                option.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: disabled
                                      ? const Color(0xFF8A94A6)
                                      : checked
                                          ? widget.themeData.checkedColor
                                          : const Color(0xFF262626),
                                  fontWeight: checked
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                      ),
                    ),
                    if (showCheckedIcon && widget.isFullRowItem != true)
                      Icon(Icons.check,
                          size: 16, color: widget.themeData.checkedColor),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyColumn() {
    return const Expanded(child: SizedBox.shrink());
  }

  Widget _buildSingleColumns() {
    final texts = BottomPickerLocalizations.resolve(context,
        texts: widget.texts, textsBuilder: widget.textsBuilder);
    final level2Options = _childrenOf(_expandedLevel1, texts: texts);
    final level3Options = _childrenOf(_expandedLevel2, texts: texts);
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            _buildSingleColumn(
                _options, _level1, _selectLevel1, _level1Controller),
            if (_maxDepth >= 2)
              level2Options.isNotEmpty
                  ? _buildSingleColumn(
                      level2Options, _level2, _selectLevel2, _level2Controller,
                      parents: [if (_expandedLevel1 != null) _expandedLevel1!])
                  : _buildEmptyColumn(),
            if (_maxDepth >= 3)
              level3Options.isNotEmpty
                  ? _buildSingleColumn(
                      level3Options, _level3, _selectLevel3, _level3Controller,
                      parents: [
                          if (_expandedLevel1 != null) _expandedLevel1!,
                          if (_expandedLevel2 != null) _expandedLevel2!
                        ])
                  : _buildEmptyColumn(),
          ],
        ));
  }

  Widget _buildMultipleColumns() {
    final texts = BottomPickerLocalizations.resolve(context,
        texts: widget.texts, textsBuilder: widget.textsBuilder);
    if (_options.isEmpty) {
      return _SelectorEmptyWidget(texts: texts);
    }
    final level2Options = _childrenOf(_expandedLevel1, texts: texts);
    final level3Options = _childrenOf(_expandedLevel2, texts: texts);
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            _buildMultipleColumn(_options, <CascadeOption>[], 0),
            if (_maxDepth >= 2 ||
                _childrenOf(_expandedLevel1, texts: texts).isNotEmpty)
              level2Options.isNotEmpty
                  ? _buildMultipleColumn(level2Options,
                      [if (_expandedLevel1 != null) _expandedLevel1!], 1)
                  : _buildEmptyColumn(),
            if (_maxDepth >= 3)
              level3Options.isNotEmpty
                  ? _buildMultipleColumn(
                      level3Options,
                      [
                        if (_expandedLevel1 != null) _expandedLevel1!,
                        if (_expandedLevel2 != null) _expandedLevel2!
                      ],
                      2)
                  : _buildEmptyColumn(),
          ],
        ));
  }

  Widget _buildMultipleColumn(
      List<CascadeOption> options, List<CascadeOption> parents, int depth) {
    final items = options
        .map((option) => _CascadeFlatItem(
            option: option, path: [...parents, option], depth: depth))
        .toList();
    if (items.isEmpty) {
      return _buildEmptyColumn();
    }
    return Expanded(
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Colors.transparent),
        itemBuilder: (context, index) {
          final item = items[index];
          final option = item.option;
          final checked = _isChecked(item);
          final visualSelected = checked || _hasCheckedDescendant(item.path);
          final expanded = _isExpandedMultiple(item);
          final disabled = _isDisabledPath(item.path);
          final selectable = _isSelectable(item);
          return InkWell(
            onTap: disabled ? null : () => _tapMultipleItem(item),
            child: Container(
              height: 38,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: disabled
                  ? const Color(0x0A000000)
                  : expanded || visualSelected
                      ? widget.themeData.selectedOptionBackgroundColor
                      : Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (selectable)
                    SizedBox(
                      width: 30,
                      height: 24,
                      child: Checkbox(
                        value: checked,
                        activeColor: widget.themeData.checkedColor,
                        onChanged:
                            disabled ? null : (_) => _toggleMultiple(item),
                      ),
                    ),
                  Expanded(
                    child: Align(
                      alignment: widget.alignment ?? Alignment.centerLeft,
                      child: widget.itemBuilder != null
                          ? widget.itemBuilder!(
                              context, setState, option, visualSelected)
                          : Text(
                              option.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: disabled
                                    ? const Color(0xFF8A94A6)
                                    : visualSelected
                                        ? widget.themeData.checkedColor
                                        : const Color(0xFF262626),
                                fontWeight: visualSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                    ),
                  ),
                  if (_hasMultipleChildren(item))
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: expanded
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
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final texts = BottomPickerLocalizations.resolve(context,
        texts: widget.texts, textsBuilder: widget.textsBuilder);
    return ClipRRect(
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
                  : mediaQuery.size.height * 0.55 + mediaQuery.padding.bottom,
              minHeight: widget.height != null
                  ? widget.height! + mediaQuery.padding.bottom
                  : mediaQuery.size.height * 0.45 + mediaQuery.padding.bottom,
            ),
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
                  const Divider(height: 1, color: Color(0xFFEFF0F6)),
                Expanded(
                  child: widget.mode == SelectionMode.MULTIPLE
                      ? _buildMultipleColumns()
                      : _options.isEmpty
                          ? _SelectorEmptyWidget(texts: texts)
                          : _buildSingleColumns(),
                ),
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
                          height: 43,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: widget.themeData.buttonBorderColor),
                              borderRadius: widget.themeData.buttonBorderRadius,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.only(
                                        topLeft: widget.themeData
                                            .buttonBorderRadius.topLeft,
                                        bottomLeft: widget.themeData
                                            .buttonBorderRadius.bottomLeft),
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Center(
                                      child: Text(
                                        texts.cancel,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: widget
                                              .themeData.buttonBorderColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: double.infinity,
                                  color: widget.themeData.buttonBorderColor,
                                ),
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.only(
                                        topRight: widget.themeData
                                            .buttonBorderRadius.topRight,
                                        bottomRight: widget.themeData
                                            .buttonBorderRadius.bottomRight),
                                    onTap: () => Navigator.of(context).pop(
                                        widget.mode == SelectionMode.MULTIPLE
                                            ? <CascadeSelection>[]
                                            : const CascadeSelection.empty()),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: widget
                                            .themeData.buttonBackgroundColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: widget.themeData
                                                .buttonBorderRadius.topRight,
                                            bottomRight: widget
                                                .themeData
                                                .buttonBorderRadius
                                                .bottomRight),
                                      ),
                                      child: Center(
                                        child: Text(
                                          texts.reset,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                                : () => Navigator.of(context).pop(
                                    widget.mode == SelectionMode.MULTIPLE
                                        ? _selectedValues.values.toList()
                                        : _selection()),
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
                              disabledMouseCursor: SystemMouseCursors.forbidden,
                            ),
                            child: Text(
                              texts.confirm,
                              style: const TextStyle(
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
    );
  }
}

class _CascadeFlatItem {
  final CascadeOption option;
  final List<CascadeOption> path;
  final int depth;

  const _CascadeFlatItem({
    required this.option,
    required this.path,
    required this.depth,
  });
}
