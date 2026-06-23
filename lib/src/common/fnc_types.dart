part of flutter_bottom_sheet_pickers.src;

/// Builds a custom row for an option.
///
/// The [checked] flag tells whether [option] is currently selected. Call
/// [setModalState] if the custom row owns transient state that must rebuild
/// inside the bottom sheet.
typedef ItemBuilder<T> = Widget Function(
    BuildContext context, StateSetter setModalState, T option, bool checked);

/// Loads the next page of options for lazy pickers.
///
/// The picker adds `page_index`, `page_size`, and `keyword` to [params].
/// Return the current page as a list of options. Returning an empty list marks
/// the list as fully loaded.
typedef LazyRequestFuture<T> = Future<List<T>> Function(
    Map<String, dynamic> params);

/// Builds picker texts from the current build context.
typedef BottomPickerLocalizationBuilder = BottomPickerLocalizations Function(
    BuildContext context);
