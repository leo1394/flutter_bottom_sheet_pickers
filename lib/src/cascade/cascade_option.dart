part of flutter_bottom_sheet_pickers.src;

/// Option node used by cascade pickers.
///
/// A node can represent any level in the cascade tree. The picker currently
/// displays up to three levels.
class CascadeOption {
  /// Unique identifier of this option.
  ///
  /// Initial selections created with [CascadeSelection.byIds] match against
  /// this value.
  final String id;

  /// Display label shown in the picker.
  final String label;

  /// Optional custom value associated with this option.
  final dynamic value;

  /// Child options shown in the next cascade level.
  final List<CascadeOption> children;

  /// Creates a cascade option.
  const CascadeOption({
    required this.id,
    required this.label,
    this.value,
    this.children = const [],
  });

  /// Returns the display label.
  @override
  String toString() => label;
}
