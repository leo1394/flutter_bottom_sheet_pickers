part of flutter_bottom_sheet_pickers.src;

/// Chainable builder for a multiple-selection cascade bottom sheet picker.
class BottomSheetCascadeMultiplePicker {
  final _BottomSheetPicker<CascadeOption> _picker;

  BottomSheetCascadeMultiplePicker._(this._picker);

  /// Sets the picker title.
  ///
  /// Passing null hides the title text.
  BottomSheetCascadeMultiplePicker title(String? title) {
    _picker.title = title;
    return this;
  }

  /// Sets cascade options from CascadeOption, map, or dynamic list data.
  ///
  /// Supported shapes are `List<CascadeOption>`, map-like lists with `children`,
  /// and adjacency maps keyed by parent id.
  BottomSheetCascadeMultiplePicker options(dynamic options) {
    _picker._cascadeOptions = options;
    return this;
  }

  /// Sets initially selected cascade paths.
  ///
  /// Use [CascadeSelection.byIds] when restoring persisted paths by ids.
  BottomSheetCascadeMultiplePicker initialValues(
      List<CascadeSelection> initialValue) {
    _picker._cascadeInitialValue = initialValue;
    _picker._tempSelected = initialValue;
    return this;
  }

  /// Sets option ids or values that cannot be selected.
  ///
  /// Disabled values are compared against cascade option ids and values.
  BottomSheetCascadeMultiplePicker disabledValues(
      List<dynamic> disabledValues) {
    _picker._disabledValues = disabledValues;
    return this;
  }

  /// Adds an "All" option where supported by the current cascade level.
  ///
  /// [allItemLabel] overrides the localized label for this picker.
  BottomSheetCascadeMultiplePicker cascadeAllItemSupported(
      {String? allItemLabel}) {
    _picker.cascadeAllItemSupported(allItemLabel: allItemLabel);
    return this;
  }

  /// Makes the whole row tappable and optionally provides a custom row builder.
  BottomSheetCascadeMultiplePicker fullRow(
      {ItemBuilder<CascadeOption>? itemBuilder}) {
    _picker.fullRow(itemBuilder: itemBuilder);
    return this;
  }

  /// Sets option content alignment and optionally provides a custom row builder.
  BottomSheetCascadeMultiplePicker align(Alignment alignment,
      {ItemBuilder<CascadeOption>? itemBuilder}) {
    _picker.align(alignment, itemBuilder: itemBuilder);
    return this;
  }

  /// Allows confirm with no selected cascade paths.
  ///
  /// Without this, the confirm button is disabled until at least one path is
  /// selected.
  BottomSheetCascadeMultiplePicker allowNoSelection() {
    _picker.allowNoSelection();
    return this;
  }

  /// Shows the picker and returns selected paths, or null when cancelled.
  Future<List<CascadeSelection>?> show() async {
    final result = await _picker.show();
    return result as List<CascadeSelection>?;
  }
}
