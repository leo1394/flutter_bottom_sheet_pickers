part of flutter_bottom_sheet_pickers.src;

/// Chainable builder for a multiple-selection bottom sheet picker.
class BottomSheetMultiplePicker<T> {
  final _BottomSheetPicker<T> _picker;

  BottomSheetMultiplePicker._(
    BuildContext context, {
    String? title,
    ItemBuilder<T>? itemBuilder,
    bool isFullRowItem = false,
    bool isSearchSupported = false,
    Alignment? alignment = Alignment.centerLeft,
    BottomPickerTheme themeData = BottomPickerTheme.defaults,
  }) : _picker = _BottomSheetPicker<T>(
          context,
          title: title,
          itemBuilder: itemBuilder,
          mode: SelectionMode.MULTIPLE,
          isFullRowItem: isFullRowItem,
          isSearchSupported: isSearchSupported,
          alignment: alignment,
          themeData: themeData,
        );

  /// Sets the picker title.
  ///
  /// Passing null hides the title text.
  BottomSheetMultiplePicker<T> title(String? title) {
    _picker.title = title;
    return this;
  }

  /// Sets local options, optional selected values, and disabled values.
  ///
  /// [disabledValues] are shown but cannot be selected.
  BottomSheetMultiplePicker<T> options(List<T> options,
      {List<T>? initialValue, List<T>? disabledValues}) {
    _picker.multiple(
        options: options,
        initialValue: initialValue,
        disabledValues: disabledValues);
    return this;
  }

  /// Sets the initially selected values.
  BottomSheetMultiplePicker<T> initialValues(List<T> initialValue) {
    _picker._tempSelected = {...initialValue};
    return this;
  }

  /// Sets values that cannot be selected.
  ///
  /// This can be chained after [options] or [lazyLoad].
  BottomSheetMultiplePicker<T> disabledValues(List<T> disabledValues) {
    _picker._disabledValues = disabledValues;
    return this;
  }

  /// Enables lazy loading with optional initial values and disabled values.
  ///
  /// The loader receives `page_index`, `page_size`, `keyword`, plus any custom
  /// [parameters]. Use this instead of [options] for remote data sources.
  BottomSheetMultiplePicker<T> lazyLoad(
      {required LazyRequestFuture<T>? lazyRequestFuture,
      Map<String, dynamic>? parameters,
      List<T>? initialValue,
      List<T>? disabledValues}) {
    _picker.lazyLoad(
        lazyRequestFuture: lazyRequestFuture,
        parameters: parameters,
        initialValue: initialValue,
        disabledValues: disabledValues);
    return this;
  }

  /// Enables search and optionally sets the placeholder text.
  ///
  /// With [options], search filters the local list by each option's string
  /// value. With [lazyLoad], search forwards the keyword to the loader.
  BottomSheetMultiplePicker<T> searchSupported({String? placeholder}) {
    _picker.searchSupported(placeholder: placeholder);
    return this;
  }

  /// Makes the whole row tappable and optionally provides a custom row builder.
  BottomSheetMultiplePicker<T> fullRow({ItemBuilder<T>? itemBuilder}) {
    _picker.fullRow(itemBuilder: itemBuilder);
    return this;
  }

  /// Sets option content alignment and optionally provides a custom row builder.
  BottomSheetMultiplePicker<T> align(Alignment alignment,
      {ItemBuilder<T>? itemBuilder}) {
    _picker.align(alignment, itemBuilder: itemBuilder);
    return this;
  }

  /// Allows confirm with no selected values.
  ///
  /// Without this, the confirm button is disabled until at least one value is
  /// selected.
  BottomSheetMultiplePicker<T> allowNoSelection() {
    _picker.allowNoSelection();
    return this;
  }

  /// Shows the picker and returns selected values, or null when cancelled.
  Future<List<T>?> show() async {
    final result = await _picker.show();
    return result as List<T>?;
  }
}
