part of flutter_bottom_sheet_pickers.src;

/// Reusable text configuration for multiple pickers under the same subtree.
///
/// Use this when only one page or feature should override picker labels. For
/// app-wide utility-style calls, use [BottomSheetPickers.setLocalizations].
class BottomPickerConfig extends InheritedWidget {
  static BottomPickerLocalizations? _defaultLocalizations;
  static BottomPickerLocalizationBuilder? _defaultLocalizationBuilder;

  /// Fixed picker labels.
  ///
  /// Mutually exclusive with [localizationBuilder].
  final BottomPickerLocalizations? localizations;

  /// Dynamic picker label builder.
  ///
  /// Mutually exclusive with [localizations]. Use this when labels come from
  /// the app's own localization extension.
  final BottomPickerLocalizationBuilder? localizationBuilder;

  /// Creates a picker text config.
  const BottomPickerConfig({
    super.key,
    required super.child,
    this.localizations,
    this.localizationBuilder,
  }) : assert(localizations == null || localizationBuilder == null);

  /// Configures global default labels for utility-style picker calls.
  static void setDefault(
      {BottomPickerLocalizations? localizations,
      BottomPickerLocalizationBuilder? localizationBuilder}) {
    assert(localizations == null || localizationBuilder == null);
    _defaultLocalizations = localizations;
    _defaultLocalizationBuilder = localizationBuilder;
  }

  /// Clears global default labels.
  static void clear() {
    _defaultLocalizations = null;
    _defaultLocalizationBuilder = null;
  }

  /// Global fixed labels.
  static BottomPickerLocalizations? get defaultLocalizations =>
      _defaultLocalizations;

  /// Global dynamic label builder.
  static BottomPickerLocalizationBuilder? get defaultLocalizationBuilder =>
      _defaultLocalizationBuilder;

  /// Reads the nearest config without registering a dependency.
  ///
  /// Pickers use this during sheet creation so opening a picker does not add an
  /// unnecessary inherited-widget dependency to the caller.
  static BottomPickerConfig? maybeOf(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<BottomPickerConfig>()
        ?.widget as BottomPickerConfig?;
  }

  @override
  bool updateShouldNotify(BottomPickerConfig oldWidget) {
    return localizations != oldWidget.localizations ||
        localizationBuilder != oldWidget.localizationBuilder;
  }
}
