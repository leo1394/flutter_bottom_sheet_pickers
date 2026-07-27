part of flutter_bottom_sheet_pickers.src;

/// Filter mode used by select pickers.
enum PickerFilterMode {
  /// Filter already loaded local options.
  local,

  /// Forward filter parameters to a lazy loading request.
  remote,
}

/// Option displayed in the picker filter menu.
class PickerFilterOption<F> {
  /// Filter value sent to [PickerFilter.onChanged].
  ///
  /// Use null for an "All" option.
  final F? value;

  /// Text displayed in the filter menu.
  final String label;

  /// Creates a filter option.
  const PickerFilterOption({
    required this.value,
    required this.label,
  });

  @override
  String toString() => label;
}

/// Filter configuration for single and multiple select pickers.
///
/// Use [PickerFilter.local] when filtering in-memory [options]. Use
/// [PickerFilter.remote] when filter changes should be sent to [lazyLoad]
/// parameters.
class PickerFilter<T, F> {
  /// Filter display options.
  final List<PickerFilterOption<F>> options;

  /// Initially selected filter value.
  final F? initialValue;

  /// Called whenever the filter value changes.
  final ValueChanged<F?>? onChanged;

  /// Whether this filter works locally or by lazy request parameters.
  final PickerFilterMode mode;

  /// Predicate used by local filtering.
  final bool Function(T option, F? filter)? predicate;

  /// Builds extra request parameters for remote filtering.
  final Map<String, dynamic> Function(F? filter)? parameterBuilder;

  /// Creates a local filter.
  const PickerFilter.local({
    required this.options,
    this.initialValue,
    this.onChanged,
    required bool Function(T option, F? filter) this.predicate,
  })  : mode = PickerFilterMode.local,
        parameterBuilder = null;

  /// Creates a remote filter.
  const PickerFilter.remote({
    required this.options,
    this.initialValue,
    this.onChanged,
    required Map<String, dynamic> Function(F? filter) this.parameterBuilder,
  })  : mode = PickerFilterMode.remote,
        predicate = null;

  List<PickerFilterOption<dynamic>> get displayOptions => options
      .map((option) => PickerFilterOption<dynamic>(
            value: option.value,
            label: option.label,
          ))
      .toList(growable: false);

  void notifyChanged(dynamic filter) {
    onChanged?.call(filter as F?);
  }

  bool applyPredicate(T option, dynamic filter) {
    return predicate?.call(option, filter as F?) ?? true;
  }

  Map<String, dynamic> buildParameters(dynamic filter) {
    return parameterBuilder?.call(filter as F?) ?? const <String, dynamic>{};
  }
}
