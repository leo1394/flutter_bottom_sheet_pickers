// ignore_for_file: must_be_immutable
library flutter_bottom_sheet_pickers.src;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'common/fnc_types.dart';
part 'common/selection_mode.dart';
part 'common/built_in_localizations.dart';
part 'common/bottom_sheet_picker_theme.dart';
part 'common/bottom_sheet_picker.dart';
part 'common/selector_empty_widget.dart';
part 'common/selector_list_footer.dart';
part 'flutter_bottom_picker_localizations.dart';
part 'flutter_bottom_picker_config.dart';
part 'cascade/cascade_option.dart';
part 'cascade/cascade_selection.dart';
part 'cascade/bottom_sheet_cascade_picker.dart';
part 'cascade/bottom_sheet_cascade_multiple_picker.dart';
part 'cascade/cascade_picker_content.dart';
part 'select/bottom_sheet_picker_content.dart';
part 'select/bottom_sheet_single_picker.dart';
part 'select/bottom_sheet_multiple_picker.dart';

/// Entry point for creating bottom sheet pickers.
///
/// Use [single], [multiple], or [cascade] to create a chainable picker and call
/// `show()` at the end of the chain.
class BottomSheetPickers {
  BottomSheetPickers._();

  /// Configures global default labels for all picker calls.
  ///
  /// Pass [localizations] for fixed labels, or [builder] when labels should be
  /// resolved from the current [BuildContext], such as when the app has its own
  /// localization extension.
  static void setLocalizations(
      {BottomPickerLocalizations? localizations,
      BottomPickerLocalizationBuilder? builder}) {
    BottomPickerConfig.setDefault(
        localizations: localizations, localizationBuilder: builder);
  }

  /// Clears labels configured through [setLocalizations].
  ///
  /// This is useful in tests or when an app-level language override is removed.
  static void clearLocalizations() {
    BottomPickerConfig.clear();
  }

  /// Creates a chainable single-selection picker.
  ///
  /// The picker returns the selected item when confirm is tapped. It returns
  /// `null` when the sheet is cancelled, dismissed by tapping outside, or closed
  /// by the system back action.
  ///
  /// [itemBuilder] customizes each option row. Set [isFullRowItem] to true when
  /// the custom row should own its selected indicator.
  static BottomSheetSinglePicker<T> single<T>(
    BuildContext context, {
    String? title,
    ItemBuilder<T>? itemBuilder,
    bool isFullRowItem = false,
    bool isSearchSupported = false,
    Alignment? alignment = Alignment.centerLeft,
    BottomPickerTheme themeData = BottomPickerTheme.defaults,
  }) {
    return BottomSheetSinglePicker<T>._(
      context,
      title: title,
      itemBuilder: itemBuilder,
      isFullRowItem: isFullRowItem,
      isSearchSupported: isSearchSupported,
      alignment: alignment,
      themeData: themeData,
    );
  }

  /// Creates a chainable multiple-selection picker.
  ///
  /// The picker returns a list of selected items when confirm is tapped. It
  /// returns `null` when cancelled or dismissed. The reset action returns an
  /// empty list.
  static BottomSheetMultiplePicker<T> multiple<T>(
    BuildContext context, {
    String? title,
    ItemBuilder<T>? itemBuilder,
    bool isFullRowItem = false,
    bool isSearchSupported = false,
    Alignment? alignment = Alignment.centerLeft,
    BottomPickerTheme themeData = BottomPickerTheme.defaults,
  }) {
    return BottomSheetMultiplePicker<T>._(
      context,
      title: title,
      itemBuilder: itemBuilder,
      isFullRowItem: isFullRowItem,
      isSearchSupported: isSearchSupported,
      alignment: alignment,
      themeData: themeData,
    );
  }

  /// Creates a chainable cascade picker.
  ///
  /// Cascade options can be provided as `List<CascadeOption>`, map-like lists,
  /// or adjacency maps. Single cascade pickers return a [CascadeSelection].
  /// Call `multiple()` on the returned builder to switch to multiple cascade
  /// selection.
  static BottomSheetCascadePicker cascade(
    BuildContext context, {
    String? title,
    ItemBuilder<CascadeOption>? itemBuilder,
    bool isFullRowItem = false,
    Alignment? alignment = Alignment.centerLeft,
    BottomPickerTheme themeData = BottomPickerTheme.defaults,
  }) {
    return BottomSheetCascadePicker._(
      context,
      title: title,
      itemBuilder: itemBuilder,
      isFullRowItem: isFullRowItem,
      alignment: alignment,
      themeData: themeData,
    );
  }
}
