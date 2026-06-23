part of flutter_bottom_sheet_pickers.src;

/// Selected path returned by cascade pickers.
///
/// The picker returns actual [CascadeOption] objects from the option tree. Use
/// [path] when you need the selected levels as a compact ordered list.
class CascadeSelection {
  /// Selected first-level option.
  final CascadeOption? level1;

  /// Selected second-level option.
  final CascadeOption? level2;

  /// Selected third-level option.
  final CascadeOption? level3;

  /// Whether this selection represents the reset action.
  ///
  /// This is true for [CascadeSelection.empty].
  final bool isReset;

  /// Creates a cascade selection from option objects.
  const CascadeSelection({
    this.level1,
    this.level2,
    this.level3,
    this.isReset = false,
  });

  /// Creates an empty reset selection.
  const CascadeSelection.empty()
      : level1 = null,
        level2 = null,
        level3 = null,
        isReset = true;

  /// Creates a selection placeholder from option ids.
  ///
  /// Use this for initial values when you only have persisted ids. The picker
  /// resolves the ids against the provided options before returning a result.
  factory CascadeSelection.byIds(
      dynamic level1Id, dynamic level2Id, dynamic level3Id) {
    return CascadeSelection(
      level1: level1Id == null
          ? null
          : CascadeOption(id: "$level1Id", label: "$level1Id"),
      level2: level2Id == null
          ? null
          : CascadeOption(id: "$level2Id", label: "$level2Id"),
      level3: level3Id == null
          ? null
          : CascadeOption(id: "$level3Id", label: "$level3Id"),
    );
  }

  /// Selected options ordered from first level to third level.
  List<CascadeOption> get path => [
        if (level1 != null) level1!,
        if (level2 != null) level2!,
        if (level3 != null) level3!,
      ];
}
