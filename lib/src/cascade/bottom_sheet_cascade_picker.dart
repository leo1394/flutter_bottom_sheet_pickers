part of flutter_bottom_sheet_pickers.src;

/// Chainable builder for a single-selection cascade bottom sheet picker.
class BottomSheetCascadePicker {
  final _BottomSheetPicker<CascadeOption> _picker;

  BottomSheetCascadePicker._(
    BuildContext context, {
    String? title,
    ItemBuilder<CascadeOption>? itemBuilder,
    bool isFullRowItem = false,
    Alignment? alignment = Alignment.centerLeft,
    BottomPickerTheme themeData = BottomPickerTheme.defaults,
  }) : _picker = _BottomSheetPicker<CascadeOption>(
          context,
          title: title,
          itemBuilder: itemBuilder,
          mode: SelectionMode.SINGLE,
          isFullRowItem: isFullRowItem,
          alignment: alignment,
          themeData: themeData,
        ) {
    _picker._isCascadeMode = true;
  }

  /// Sets the picker title.
  ///
  /// Passing null hides the title text.
  BottomSheetCascadePicker title(String? title) {
    _picker.title = title;
    return this;
  }

  /// Sets cascade options from CascadeOption, map, or dynamic list data.
  ///
  /// Supported shapes are `List<CascadeOption>`, map-like lists with `children`,
  /// and adjacency maps keyed by parent id.
  BottomSheetCascadePicker options(dynamic options) {
    _picker._cascadeOptions = options;
    return this;
  }

  /// Sets the initially selected cascade path.
  ///
  /// Use [CascadeSelection.byIds] when restoring a persisted path by ids.
  BottomSheetCascadePicker initialValue(CascadeSelection? initialValue) {
    _picker._cascadeInitialValue = initialValue;
    _picker._tempSelected = initialValue;
    return this;
  }

  /// Sets option ids or values that cannot be selected.
  ///
  /// Disabled values are compared against cascade option ids and values.
  BottomSheetCascadePicker disabledValues(List<dynamic> disabledValues) {
    _picker._disabledValues = disabledValues;
    return this;
  }

  /// Adds an "All" option where supported by the current cascade level.
  ///
  /// [allItemLabel] overrides the localized label for this picker.
  BottomSheetCascadePicker cascadeAllItemSupported({String? allItemLabel}) {
    _picker.cascadeAllItemSupported(allItemLabel: allItemLabel);
    return this;
  }

  /// Makes the whole row tappable and optionally provides a custom row builder.
  BottomSheetCascadePicker fullRow({ItemBuilder<CascadeOption>? itemBuilder}) {
    _picker.fullRow(itemBuilder: itemBuilder);
    return this;
  }

  /// Sets option content alignment and optionally provides a custom row builder.
  BottomSheetCascadePicker align(Alignment alignment,
      {ItemBuilder<CascadeOption>? itemBuilder}) {
    _picker.align(alignment, itemBuilder: itemBuilder);
    return this;
  }

  /// Allows confirm with no selected cascade path.
  ///
  /// Without this, the confirm button is disabled until a path is selected.
  BottomSheetCascadePicker allowNoSelection() {
    _picker.allowNoSelection();
    return this;
  }

  /// Converts this builder to a multiple-selection cascade picker.
  ///
  /// Continue chaining on the returned [BottomSheetCascadeMultiplePicker].
  BottomSheetCascadeMultiplePicker multiple() {
    _picker.mode = SelectionMode.MULTIPLE;
    return BottomSheetCascadeMultiplePicker._(_picker);
  }

  /// Shows the picker and returns the selected path, or null when cancelled.
  Future<CascadeSelection?> show() async {
    final result = await _picker.show();
    return result as CascadeSelection?;
  }
}
