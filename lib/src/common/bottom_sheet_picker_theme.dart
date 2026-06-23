part of flutter_bottom_sheet_pickers.src;

/// Visual theme used by bottom sheet pickers.
///
/// The theme intentionally keeps a small surface area: provide [primaryColor]
/// and the picker derives selected states and action button colors from it.
class BottomPickerTheme {
  /// Main color used to derive selected states and button colors.
  final Color primaryColor;

  /// Border radius applied to action buttons.
  final BorderRadius buttonBorderRadius;

  /// Creates a picker theme.
  const BottomPickerTheme({
    Color primaryColor = const Color(0xFFEC1C24),
    this.buttonBorderRadius = const BorderRadius.all(Radius.circular(24)),
  }) : primaryColor = primaryColor;

  /// Background color for primary action buttons.
  Color get buttonBackgroundColor => primaryColor;

  /// Border color for secondary action buttons.
  Color get buttonBorderColor => primaryColor;

  /// Background color for selected options.
  Color get selectedOptionBackgroundColor =>
      primaryColor.withAlpha((255 * 0.05).round());

  /// Color used by selected check marks.
  Color get checkedColor => primaryColor;

  /// Background color for disabled action buttons.
  Color get disabledButtonBackgroundColor =>
      primaryColor.withAlpha((255 * 0.30).round());

  /// Default picker theme.
  static const BottomPickerTheme defaults = BottomPickerTheme();
}
